# TypeScript Form Generator

react-hook-form + zod 기반 타입 안전한 폼을 생성합니다.

## 실행 방법

- `/ts-form 로그인` 또는 "로그인 폼 만들어줘"

## 기본 패턴

### Zod 스키마 정의
```tsx
import { z } from 'zod';

export const loginSchema = z.object({
  email: z
    .string()
    .min(1, '이메일을 입력해주세요')
    .email('올바른 이메일 형식이 아닙니다'),
  password: z
    .string()
    .min(1, '비밀번호를 입력해주세요')
    .min(8, '비밀번호는 8자 이상이어야 합니다'),
  rememberMe: z.boolean().default(false),
});

export type LoginFormData = z.infer<typeof loginSchema>;
```

### 폼 컴포넌트
```tsx
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { loginSchema, type LoginFormData } from '@/lib/validations/auth';

export function LoginForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: '',
      password: '',
      rememberMe: false,
    },
  });

  const onSubmit = async (data: LoginFormData) => {
    try {
      // API 호출
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      if (!res.ok) throw new Error('로그인 실패');
      // 성공 처리
    } catch (error) {
      // 에러 처리
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <label htmlFor="email" className="block text-sm font-medium mb-1">
          이메일
        </label>
        <input
          id="email"
          type="email"
          {...register('email')}
          className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary"
        />
        {errors.email && (
          <p className="mt-1 text-sm text-red-500">{errors.email.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="password" className="block text-sm font-medium mb-1">
          비밀번호
        </label>
        <input
          id="password"
          type="password"
          {...register('password')}
          className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary"
        />
        {errors.password && (
          <p className="mt-1 text-sm text-red-500">{errors.password.message}</p>
        )}
      </div>

      <div className="flex items-center">
        <input
          id="rememberMe"
          type="checkbox"
          {...register('rememberMe')}
          className="h-4 w-4 rounded border-gray-300"
        />
        <label htmlFor="rememberMe" className="ml-2 text-sm">
          로그인 유지
        </label>
      </div>

      <button
        type="submit"
        disabled={isSubmitting}
        className="w-full py-2 px-4 bg-primary text-white rounded-lg hover:bg-primary/90 disabled:opacity-50"
      >
        {isSubmitting ? '로그인 중...' : '로그인'}
      </button>
    </form>
  );
}
```

## Zod 스키마 패턴

### 회원가입
```tsx
export const signupSchema = z
  .object({
    name: z.string().min(2, '이름은 2자 이상'),
    email: z.string().email('올바른 이메일 형식이 아닙니다'),
    password: z
      .string()
      .min(8, '8자 이상')
      .regex(/[A-Z]/, '대문자 포함')
      .regex(/[0-9]/, '숫자 포함'),
    confirmPassword: z.string(),
    terms: z.literal(true, {
      errorMap: () => ({ message: '약관에 동의해주세요' }),
    }),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: '비밀번호가 일치하지 않습니다',
    path: ['confirmPassword'],
  });
```

### 프로필 수정
```tsx
export const profileSchema = z.object({
  nickname: z.string().min(2).max(20).optional(),
  bio: z.string().max(200).optional(),
  avatar: z
    .instanceof(File)
    .refine((file) => file.size <= 5 * 1024 * 1024, '5MB 이하')
    .refine(
      (file) => ['image/jpeg', 'image/png'].includes(file.type),
      'JPG, PNG만 가능'
    )
    .optional(),
  website: z.string().url().optional().or(z.literal('')),
});
```

### 동적 폼 (배열)
```tsx
export const orderSchema = z.object({
  items: z
    .array(
      z.object({
        productId: z.string(),
        quantity: z.number().min(1).max(99),
      })
    )
    .min(1, '최소 1개 상품 필요'),
  address: z.string().min(10, '상세 주소 입력'),
  memo: z.string().max(100).optional(),
});
```

## 고급 패턴

### useFieldArray (동적 필드)
```tsx
import { useFieldArray } from 'react-hook-form';

const { fields, append, remove } = useFieldArray({
  control,
  name: 'items',
});

return (
  <>
    {fields.map((field, index) => (
      <div key={field.id}>
        <input {...register(`items.${index}.name`)} />
        <button type="button" onClick={() => remove(index)}>
          삭제
        </button>
      </div>
    ))}
    <button type="button" onClick={() => append({ name: '' })}>
      추가
    </button>
  </>
);
```

### watch로 조건부 렌더링
```tsx
const watchRole = watch('role');

return (
  <>
    <select {...register('role')}>
      <option value="user">일반</option>
      <option value="admin">관리자</option>
    </select>

    {watchRole === 'admin' && (
      <input {...register('adminCode')} placeholder="관리자 코드" />
    )}
  </>
);
```

### Server Action 연동
```tsx
// app/actions.ts
'use server';

import { loginSchema } from '@/lib/validations';

export async function loginAction(formData: FormData) {
  const data = Object.fromEntries(formData);
  const validated = loginSchema.safeParse(data);

  if (!validated.success) {
    return { error: validated.error.flatten().fieldErrors };
  }

  // 로그인 로직
  return { success: true };
}

// 컴포넌트에서
import { useFormState } from 'react-dom';
const [state, formAction] = useFormState(loginAction, null);
```

## 유효성 검사 메시지 (한국어)

```tsx
const koreanErrorMap: z.ZodErrorMap = (issue, ctx) => {
  switch (issue.code) {
    case z.ZodIssueCode.too_small:
      return { message: `최소 ${issue.minimum}자 이상` };
    case z.ZodIssueCode.too_big:
      return { message: `최대 ${issue.maximum}자 이하` };
    case z.ZodIssueCode.invalid_type:
      return { message: '올바른 형식이 아닙니다' };
    default:
      return { message: ctx.defaultError };
  }
};

z.setErrorMap(koreanErrorMap);
```

## 체크리스트

- [ ] Zod 스키마 정의
- [ ] TypeScript 타입 추론 (z.infer)
- [ ] 에러 메시지 표시
- [ ] 로딩 상태 처리
- [ ] 접근성 (label, aria)
- [ ] 서버 에러 핸들링
