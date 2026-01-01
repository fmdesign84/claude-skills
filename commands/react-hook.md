# React Hook Generator

커스텀 훅과 데이터 페칭 훅을 생성합니다.

## 실행 방법

- `/react-hook useDebounce` 또는 "디바운스 훅 만들어줘"

## 커스텀 훅 패턴

### useDebounce
```tsx
import { useState, useEffect } from 'react';

export function useDebounce<T>(value: T, delay: number = 500): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);

  return debouncedValue;
}

// 사용 예시
const [search, setSearch] = useState('');
const debouncedSearch = useDebounce(search, 300);
```

### useLocalStorage
```tsx
import { useState, useEffect } from 'react';

export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T | ((val: T) => T)) => void] {
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === 'undefined') return initialValue;
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch {
      return initialValue;
    }
  });

  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      if (typeof window !== 'undefined') {
        window.localStorage.setItem(key, JSON.stringify(valueToStore));
      }
    } catch (error) {
      console.error(error);
    }
  };

  return [storedValue, setValue];
}
```

### useMediaQuery
```tsx
import { useState, useEffect } from 'react';

export function useMediaQuery(query: string): boolean {
  const [matches, setMatches] = useState(false);

  useEffect(() => {
    const media = window.matchMedia(query);
    if (media.matches !== matches) {
      setMatches(media.matches);
    }
    const listener = () => setMatches(media.matches);
    media.addEventListener('change', listener);
    return () => media.removeEventListener('change', listener);
  }, [matches, query]);

  return matches;
}

// 사용 예시
const isMobile = useMediaQuery('(max-width: 768px)');
const isDark = useMediaQuery('(prefers-color-scheme: dark)');
```

### useClickOutside
```tsx
import { useEffect, useRef, type RefObject } from 'react';

export function useClickOutside<T extends HTMLElement>(
  handler: () => void
): RefObject<T> {
  const ref = useRef<T>(null);

  useEffect(() => {
    const listener = (event: MouseEvent | TouchEvent) => {
      if (!ref.current || ref.current.contains(event.target as Node)) {
        return;
      }
      handler();
    };

    document.addEventListener('mousedown', listener);
    document.addEventListener('touchstart', listener);
    return () => {
      document.removeEventListener('mousedown', listener);
      document.removeEventListener('touchstart', listener);
    };
  }, [handler]);

  return ref;
}

// 사용 예시
const ref = useClickOutside<HTMLDivElement>(() => setIsOpen(false));
return <div ref={ref}>{/* dropdown */}</div>;
```

### useToggle
```tsx
import { useState, useCallback } from 'react';

export function useToggle(initialValue: boolean = false) {
  const [value, setValue] = useState(initialValue);

  const toggle = useCallback(() => setValue(v => !v), []);
  const setTrue = useCallback(() => setValue(true), []);
  const setFalse = useCallback(() => setValue(false), []);

  return { value, toggle, setTrue, setFalse };
}
```

## TanStack Query 패턴

### 기본 쿼리
```tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

// 조회
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const res = await fetch('/api/users');
      if (!res.ok) throw new Error('Failed to fetch');
      return res.json();
    },
    staleTime: 1000 * 60 * 5, // 5분
  });
}

// 단일 조회
export function useUser(id: string) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: async () => {
      const res = await fetch(`/api/users/${id}`);
      if (!res.ok) throw new Error('Failed to fetch');
      return res.json();
    },
    enabled: !!id, // id가 있을 때만 실행
  });
}
```

### 뮤테이션
```tsx
export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: CreateUserInput) => {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      if (!res.ok) throw new Error('Failed to create');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// 사용 예시
const { mutate, isPending } = useCreateUser();
mutate({ name: '홍길동', email: 'hong@example.com' });
```

### Optimistic Update
```tsx
export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: updateUser,
    onMutate: async (newUser) => {
      await queryClient.cancelQueries({ queryKey: ['users', newUser.id] });
      const previousUser = queryClient.getQueryData(['users', newUser.id]);
      queryClient.setQueryData(['users', newUser.id], newUser);
      return { previousUser };
    },
    onError: (err, newUser, context) => {
      queryClient.setQueryData(['users', newUser.id], context?.previousUser);
    },
    onSettled: (data, error, variables) => {
      queryClient.invalidateQueries({ queryKey: ['users', variables.id] });
    },
  });
}
```

### Infinite Query
```tsx
export function useInfiniteUsers() {
  return useInfiniteQuery({
    queryKey: ['users', 'infinite'],
    queryFn: async ({ pageParam = 0 }) => {
      const res = await fetch(`/api/users?page=${pageParam}&limit=20`);
      return res.json();
    },
    getNextPageParam: (lastPage) => lastPage.nextCursor,
    initialPageParam: 0,
  });
}
```

## Zustand 패턴

### 스토어 생성
```tsx
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  login: (user: User) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isAuthenticated: false,
      login: (user) => set({ user, isAuthenticated: true }),
      logout: () => set({ user: null, isAuthenticated: false }),
    }),
    {
      name: 'auth-storage',
    }
  )
);

// 사용
const { user, login, logout } = useAuthStore();
```

## 훅 작성 규칙

1. `use` 접두사 필수
2. 최상위에서만 호출
3. 컴포넌트 또는 다른 훅에서만 호출
4. 의존성 배열 정확히 명시
5. cleanup 함수로 메모리 누수 방지
