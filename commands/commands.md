# 스킬 통합 허브

모든 스킬의 목록과 연동 정보를 관리합니다.

## 실행 방법

- `/commands` - 사용 가능한 스킬 목록

## 스킬 목록 (10개)

### 🎯 메타 스킬
| 스킬 | 명령어 | 용도 |
|------|--------|------|
| **Kickoff** | `/kickoff` | 프로젝트 분석 → 스킬 조합 제안 |
| **Strategy** | `/strategy` | 스킬 활용 전략/워크플로우 |
| **Commands** | `/commands` | 스킬 목록 (현재 문서) |

### 🏗️ 코드 생성 스킬
| 스킬 | 명령어 | 용도 |
|------|--------|------|
| **Next Page** | `/next-page` | Next.js 14 페이지/레이아웃 |
| **TW Component** | `/tw-component` | Tailwind UI 컴포넌트 |
| **React Hook** | `/react-hook` | 커스텀 훅, TanStack Query |
| **TS Form** | `/ts-form` | react-hook-form + zod |
| **API Route** | `/api-route` | Next.js Route Handlers |

### 🔧 유틸리티 스킬
| 스킬 | 명령어 | 용도 |
|------|--------|------|
| **FTW** | `/ftw` | Figma → 웹 컴포넌트 |
| **Gen AI** | `/gen-ai` | AI 이미지/영상 생성 |
| **Error Doctor** | `/error-doctor` | 에러 분석/해결 |

## 스킬 연동 맵

```
         /kickoff (오케스트레이터)
              │
    ┌─────────┼─────────┐
    ▼         ▼         ▼
/api-route  /next-page  /ftw
    │         │         │
    ▼         ▼         ▼
/react-hook /tw-component /gen-ai
    │         │         │
    └────┬────┴────┬────┘
         ▼         ▼
     /ts-form  /error-doctor
```

## 빠른 시작

```bash
# 새 프로젝트 시작
/kickoff "프로젝트 설명"

# 개별 스킬 사용
/next-page dashboard
/tw-component Button
/api-route users
```

## 스킬 추가 방법

`~/.claude/commands/` 폴더에 `.md` 파일 추가:

```markdown
# 스킬 이름

설명...

## 실행 방법
- `/스킬명` 또는 "트리거 문구"

## 작동 방식
...
```

## 스킬 현황

```
스킬 생태계 성숙도: [████████░░] 80%

✅ 완료: UI, 페이지, API, 훅, 폼
⚠️ 필요: 인증, DB, 테스트
❌ 미정: 배포, SEO, i18n
```

## 버전

- **v1.1** (2025-01-02): /kickoff 오케스트레이터 추가
- **v1.0** (2025-01-01): 초기 9개 스킬
