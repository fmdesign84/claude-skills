# 전역 설정

## 나에 대해
- 기획자 + 디자이너 + 퍼블리셔 + 개발자 (풀스택 1인 체제)
- AI 스튜디오/앱 제작이 주력
- 빠른 프로토타이핑 → 점진적 완성도 향상 선호

## 기술 스택

### 코어
- Next.js 14+ (App Router)
- React 18+ / TypeScript 5+
- Tailwind CSS 3+

### 상태/데이터
- 전역 상태: Zustand (단순) 또는 Context (아주 단순한 경우)
- 서버 상태: TanStack Query (React Query)
- 폼: react-hook-form + zod

### AI 통합
- Claude API, OpenAI API, 로컬 LLM 혼용
- AI SDK (Vercel AI SDK) 활용 가능

## 코딩 규칙

### 언어 스타일
- 주석/커밋: 한국어
- 변수/함수: 영어 camelCase
- 컴포넌트/타입: 영어 PascalCase
- 상수: UPPER_SNAKE_CASE

### TypeScript
- `any` 금지 → `unknown` 후 타입 가드
- 타입 명시적 정의 (추론에만 의존 X)
- interface > type (확장성)
- as 단언 최소화

### React 패턴
```
- 함수형 컴포넌트만
- 커스텀 훅으로 로직 분리
- 서버 컴포넌트 우선, 필요시만 'use client'
- Props는 interface로 정의
- children 있으면 PropsWithChildren 활용
```

### 컴포넌트 구조
```
components/
  Button/
    index.tsx        # 메인 컴포넌트
    Button.types.ts  # 타입 (필요시)
    Button.test.tsx  # 테스트 (필요시)
```

### 에러 처리
```tsx
// API 호출: try-catch + 사용자 친화적 메시지
try {
  const data = await fetchData();
} catch (error) {
  toast.error('데이터를 불러오지 못했습니다');
  console.error(error); // 개발용
}

// React: ErrorBoundary로 UI 크래시 방지
// 로딩: Suspense + Skeleton UI 선호
```

### API 통신
```tsx
// TanStack Query 패턴
const { data, isLoading, error } = useQuery({
  queryKey: ['users', id],
  queryFn: () => fetchUser(id),
});

// 서버 액션 (Next.js) 적극 활용
// API Route는 외부 연동 필요시만
```

## 디자인 → 코드

### Figma 기반 작업
- 디자인 토큰 있으면 tailwind.config에 매핑
- 컴포넌트 단위로 쪼개서 구현
- 간격/크기는 Figma 수치 그대로 (px → rem 변환)
- 폰트: 시스템 폰트 또는 next/font

### 이미지/스크린샷 기반
- 최대한 동일하게 재현
- 불명확한 부분은 물어보기
- 반응형은 확인 후 작업

### 반응형 브레이크포인트
```
sm: 640px   (모바일 가로)
md: 768px   (태블릿)
lg: 1024px  (작은 데스크탑)
xl: 1280px  (데스크탑)
```

## AI 스튜디오 작업

### 프롬프트 관리
- 시스템 프롬프트: 별도 파일로 분리 (prompts/ 또는 lib/prompts/)
- 버전 관리: Git으로 추적
- 환경별 분리: .env로 API 키 관리

### AI 응답 처리
- 스트리밍 UI 구현 (타이핑 효과)
- 에러 시 재시도 버튼 제공
- 토큰 사용량 로깅 (비용 관리)

### 보안
- API 키는 절대 클라이언트 노출 금지
- 서버 사이드에서만 AI API 호출
- 사용자 입력 sanitize

## 품질 기준

### 성능
- Lighthouse Performance > 90
- LCP < 2.5s, CLS < 0.1, FID < 100ms
- 이미지: next/image + WebP/AVIF
- 번들: dynamic import로 코드 스플리팅

### 접근성
- 시맨틱 HTML (header, main, nav, button 등)
- 키보드 네비게이션 작동
- 포커스 표시 명확히
- aria-label 필요한 곳에 추가
- 색상 대비 4.5:1 이상

### 코드
- 중요 로직 테스트 필수
- console.log 커밋 금지 (디버깅 후 제거)
- TODO 주석은 이슈 번호와 함께

## Git

### 커밋 메시지 (한국어)
```
feat: 로그인 기능 추가
fix: 버튼 클릭 안 되는 문제 수정
refactor: API 호출 로직 분리
style: 버튼 호버 효과 추가
docs: README 업데이트
test: 로그인 테스트 추가
chore: 패키지 업데이트
```

### 브랜치
- main: 프로덕션
- develop: 개발 (있는 경우)
- feature/*: 기능 개발
- fix/*: 버그 수정

## 작업 방식

### Claude에게 바라는 것
- 복잡한 작업 → 계획 먼저 보여주고 승인 후 진행
- 파일 수정 전 → 현재 코드 먼저 읽기
- 모르면 → 추측 말고 질문
- 선택지 있으면 → 옵션 제시하고 내가 선택

### 코드 작성 원칙
- 한 번에 한 가지만 변경
- 동작하는 최소 단위로 진행
- 과도한 추상화 금지
- 미래 대비 코드 금지 (YAGNI)

### 변경 후 검증 (필수)
- 코드 변경/추가 후 → `npm run build` 실행
- 에러 발생 시 → 즉시 수정 후 재빌드
- 모든 에러 해결될 때까지 반복
- TypeScript 에러 특히 주의 (implicit any 등)

### 금지 사항
- 요청 없는 파일 생성
- README/문서 임의 생성
- 불필요한 주석 ("이 함수는..." 류)
- 요청 없는 리팩토링
- 동작하는 코드 스타일만 변경

## 자주 쓰는 도구

### 패키지 매니저
- pnpm 선호 (없으면 npm)

### 린팅/포맷팅
- ESLint + Prettier
- 설정 있으면 따르기, 없으면 기본값

### 배포
- Vercel 주로 사용
- /vercel:deploy 명령어 활용

### 디자인
- /figma:implement-design 으로 Figma 연동
- /frontend-design:frontend-design 으로 고품질 UI 생성
