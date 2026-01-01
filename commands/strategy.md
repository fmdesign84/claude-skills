# 스킬 활용 전략

Claude Code 스킬을 효율적으로 활용하기 위한 워크플로우와 전략입니다.

## 스킬 맵

```
┌─────────────────────────────────────────────────────────────┐
│                      프로젝트 시작                           │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │ next-page│   │ api-route│   │   ftw    │
        │ 페이지    │   │   API    │   │  디자인  │
        └────┬─────┘   └────┬─────┘   └────┬─────┘
             │              │              │
             ▼              ▼              ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │tw-component│ │react-hook│   │  gen-ai  │
        │   UI     │   │  로직    │   │  이미지  │
        └────┬─────┘   └────┬─────┘   └────┬─────┘
             │              │              │
             └───────────┬──┴──────────────┘
                         ▼
                   ┌──────────┐
                   │ ts-form  │
                   │   폼     │
                   └────┬─────┘
                        │
              ┌─────────┴─────────┐
              ▼                   ▼
        ┌──────────┐        ┌──────────┐
        │error-doctor│      │ commands │
        │  디버깅   │        │   허브   │
        └──────────┘        └──────────┘
```

## 워크플로우별 스킬 조합

### 1. 새 기능 개발 (Full Stack)

```
시나리오: "상품 목록 페이지 만들어줘"

Step 1: /api-route products
        → GET /api/products (목록)
        → POST /api/products (생성)
        → GET /api/products/[id] (상세)

Step 2: /react-hook useProducts
        → useQuery로 데이터 페칭 훅
        → useMutation으로 생성/수정 훅

Step 3: /tw-component ProductCard
        → 상품 카드 UI 컴포넌트
        → variants: default, featured, soldOut

Step 4: /next-page products
        → app/products/page.tsx (목록)
        → app/products/[id]/page.tsx (상세)
        → loading.tsx, error.tsx 포함

Step 5: (필요시) /gen-ai "상품 플레이스홀더 이미지"
```

### 2. 폼 기능 개발

```
시나리오: "회원가입 폼 만들어줘"

Step 1: /ts-form 회원가입
        → Zod 스키마 (이메일, 비밀번호, 이름)
        → react-hook-form 컴포넌트
        → 유효성 검사 메시지

Step 2: /tw-component Input, Button
        → 폼에 사용할 UI 컴포넌트

Step 3: /api-route auth/register
        → POST /api/auth/register
        → 서버 사이드 유효성 검사

Step 4: /react-hook useAuth
        → 인증 상태 관리 (Zustand)
        → 로그인/로그아웃 액션
```

### 3. 디자인 → 코드

```
시나리오: "Figma 디자인 구현해줘"

Step 1: /ftw [Figma URL]
        → 디자인 분석
        → 기존 컴포넌트 매칭
        → 새 컴포넌트 식별

Step 2: /tw-component [필요한 컴포넌트들]
        → 재사용 가능한 UI 컴포넌트 생성

Step 3: /next-page [페이지명]
        → 컴포넌트 조합하여 페이지 구성

Step 4: (필요시) /gen-ai "디자인에 맞는 이미지"
```

### 4. 에러 해결

```
시나리오: "왜 안 되지?"

Step 1: /error-doctor
        → 에러 메시지 분석
        → 원인 파악
        → 해결책 제시

Step 2: (필요시) 관련 스킬 호출
        → API 문제: /api-route 수정
        → 타입 문제: 타입 재정의
        → 훅 문제: /react-hook 수정
```

## 스킬 호출 트리거

| 상황 | 자동 트리거 스킬 |
|------|-----------------|
| "페이지 만들어줘" | `/next-page` |
| "컴포넌트 만들어줘" | `/tw-component` |
| "훅 만들어줘" | `/react-hook` |
| "폼 만들어줘" | `/ts-form` |
| "API 만들어줘" | `/api-route` |
| Figma URL 제공 | `/ftw` |
| "이미지 만들어줘" | `/gen-ai` |
| 에러 발생/질문 | `/error-doctor` |

## 프로젝트 타입별 추천 조합

### SaaS 대시보드
```
필수: next-page, tw-component, react-hook, api-route
권장: ts-form (설정 폼), gen-ai (차트 플레이스홀더)
```

### 이커머스
```
필수: next-page, tw-component, ts-form, api-route, react-hook
권장: gen-ai (상품 이미지), ftw (디자인 구현)
```

### 랜딩 페이지
```
필수: next-page, tw-component
권장: ftw (디자인 구현), gen-ai (히어로 이미지), ts-form (CTA 폼)
```

### AI 앱
```
필수: next-page, api-route, react-hook
권장: gen-ai (이미지 생성), tw-component (결과 UI)
```

## 효율 극대화 팁

### 1. 순차적 호출
```
❌ 한 번에 모든 것 요청
   "전체 쇼핑몰 만들어줘"

✅ 단계별 요청
   "먼저 상품 API 만들어줘" → /api-route
   "이제 상품 카드 만들어줘" → /tw-component
   "목록 페이지 만들어줘" → /next-page
```

### 2. 컨텍스트 유지
```
✅ 같은 세션에서 연속 작업
   → 이전에 만든 컴포넌트 자동 인식
   → 일관된 네이밍/스타일 유지
```

### 3. 구체적 요청
```
❌ "버튼 만들어줘"

✅ "primary, secondary, ghost variant 있는
    로딩 상태 지원하는 버튼 만들어줘"
```

### 4. 에러 시 즉시 디버깅
```
에러 발생 → /error-doctor 호출 → 원인 파악 → 수정
(빌드 에러 누적시키지 말고 바로 해결)
```

## 스킬 조합 단축키

자주 쓰는 조합을 기억해두세요:

| 조합 | 용도 |
|------|------|
| `api-route` → `react-hook` | 백엔드 + 프론트 데이터 레이어 |
| `tw-component` → `next-page` | UI + 페이지 구성 |
| `ts-form` → `api-route` | 폼 + 서버 처리 |
| `ftw` → `tw-component` → `next-page` | 디자인 → 코드 풀 파이프라인 |

## 품질 체크리스트

매 작업 완료 후:

- [ ] TypeScript 에러 없음
- [ ] 빌드 성공 (`npm run build`)
- [ ] 반응형 확인
- [ ] 접근성 기본 충족
- [ ] 로딩/에러 상태 처리
