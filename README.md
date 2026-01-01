# Claude Code Skills

React, Next.js, TypeScript, Tailwind 기반 개발을 위한 Claude Code 스킬 모음입니다.

## 설치

```bash
git clone https://github.com/fmdesign84/claude-skills.git
cd claude-skills
./install.sh
```

## 스킬 목록 (11개)

### 🎯 메타 스킬
| 스킬 | 명령어 | 용도 |
|------|--------|------|
| Kickoff | `/kickoff` | 프로젝트 분석 → 스킬 조합 제안 |
| Strategy | `/strategy` | 스킬 활용 전략/워크플로우 |
| Commands | `/commands` | 스킬 목록 확인 |

### 🏗️ 코드 생성 스킬
| 스킬 | 명령어 | 용도 |
|------|--------|------|
| Next Page | `/next-page` | Next.js 14 App Router 페이지 |
| TW Component | `/tw-component` | Tailwind + cva UI 컴포넌트 |
| React Hook | `/react-hook` | 커스텀 훅, TanStack Query, Zustand |
| TS Form | `/ts-form` | react-hook-form + zod 폼 |
| API Route | `/api-route` | Next.js Route Handlers |

### 🔧 유틸리티 스킬
| 스킬 | 명령어 | 용도 |
|------|--------|------|
| FTW | `/ftw` | Figma → 웹 컴포넌트 변환 |
| Gen AI | `/gen-ai` | AI 이미지/영상 생성 |
| Error Doctor | `/error-doctor` | 에러 분석/해결 |

## 사용법

### 새 프로젝트 시작
```bash
/kickoff "AI 이미지 생성 SaaS. 사용자 인증, 크레딧 시스템 필요"
```

### 개별 스킬 사용
```bash
/next-page dashboard      # 대시보드 페이지 생성
/tw-component Button      # 버튼 컴포넌트 생성
/api-route users          # 사용자 API 생성
/ts-form 로그인           # 로그인 폼 생성
```

## 기술 스택

```
✅ Next.js 14+ (App Router, Server Components)
✅ React 18+ (Hooks, Suspense)
✅ TypeScript 5+ (타입 추론, Zod)
✅ Tailwind CSS 3+ (cva, cn 유틸)
✅ TanStack Query (데이터 페칭)
✅ Zustand (상태 관리)
✅ react-hook-form + zod (폼)
```

## 워크플로우

```
/kickoff (분석)
   │
   ├─→ /api-route (API)
   │      └─→ /react-hook (데이터 훅)
   │
   ├─→ /tw-component (UI)
   │      └─→ /next-page (페이지)
   │
   └─→ /ts-form (폼)
          └─→ /error-doctor (디버깅)
```

## 수동 설치

install.sh 대신 직접 설치:

```bash
# 심볼릭 링크 (권장 - 업데이트 쉬움)
ln -sf $(pwd)/commands/* ~/.claude/commands/

# 또는 복사
cp commands/* ~/.claude/commands/
```

## 업데이트

```bash
cd claude-skills
git pull
./install.sh  # 심볼릭 링크면 자동 반영
```

## 스킬 커스터마이징

`commands/` 폴더의 `.md` 파일을 수정하면 됩니다.

새 스킬 추가:
```bash
# commands/my-skill.md 생성
# → /my-skill 명령어로 사용 가능
```

## 라이선스

MIT
