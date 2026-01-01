# Next.js Page Generator

Next.js 14+ App Router 기반 페이지/레이아웃을 생성합니다.

## 실행 방법

- `/next-page 페이지명` 또는 "페이지 만들어줘"

## 생성 패턴

### 서버 컴포넌트 (기본)
```tsx
// app/dashboard/page.tsx
import { Suspense } from 'react';
import { DashboardContent } from '@/components/dashboard';
import { DashboardSkeleton } from '@/components/skeletons';

export const metadata = {
  title: 'Dashboard',
  description: '대시보드 페이지',
};

export default async function DashboardPage() {
  return (
    <main className="container mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">대시보드</h1>
      <Suspense fallback={<DashboardSkeleton />}>
        <DashboardContent />
      </Suspense>
    </main>
  );
}
```

### 클라이언트 컴포넌트 (인터랙션 필요시)
```tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function InteractivePage() {
  const router = useRouter();
  const [isOpen, setIsOpen] = useState(false);

  return (
    // ...
  );
}
```

### 레이아웃
```tsx
// app/dashboard/layout.tsx
import { Sidebar } from '@/components/layout';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen">
      <Sidebar />
      <main className="flex-1">{children}</main>
    </div>
  );
}
```

### 로딩 UI
```tsx
// app/dashboard/loading.tsx
import { Skeleton } from '@/components/ui';

export default function Loading() {
  return (
    <div className="container mx-auto px-4 py-8">
      <Skeleton className="h-8 w-48 mb-6" />
      <Skeleton className="h-64 w-full" />
    </div>
  );
}
```

### 에러 핸들링
```tsx
'use client';

// app/dashboard/error.tsx
export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[400px]">
      <h2 className="text-xl font-semibold mb-4">문제가 발생했습니다</h2>
      <button
        onClick={reset}
        className="px-4 py-2 bg-primary text-white rounded-lg"
      >
        다시 시도
      </button>
    </div>
  );
}
```

## 데이터 페칭 패턴

### Server Component에서 직접 fetch
```tsx
async function getData() {
  const res = await fetch('https://api.example.com/data', {
    next: { revalidate: 3600 }, // ISR: 1시간
  });
  if (!res.ok) throw new Error('Failed to fetch');
  return res.json();
}

export default async function Page() {
  const data = await getData();
  return <div>{/* ... */}</div>;
}
```

### Server Action 사용
```tsx
// app/actions.ts
'use server';

import { revalidatePath } from 'next/cache';

export async function createItem(formData: FormData) {
  const title = formData.get('title');
  // DB 저장 로직
  revalidatePath('/items');
}
```

## 파일 구조

```
app/
├── (auth)/
│   ├── login/page.tsx
│   └── register/page.tsx
├── (dashboard)/
│   ├── layout.tsx
│   ├── page.tsx
│   └── settings/page.tsx
├── api/
│   └── [...route]/route.ts
├── layout.tsx
├── page.tsx
└── globals.css
```

## 체크리스트

- [ ] 서버/클라이언트 컴포넌트 구분
- [ ] metadata 설정
- [ ] loading.tsx 추가
- [ ] error.tsx 추가
- [ ] Suspense 경계 설정
- [ ] 타입 정의 완료
