# FTW (Figma to Web)

Figma 디자인을 웹 컴포넌트로 변환하는 스킬입니다.

## 실행 방법

- `/ftw` 또는 "Figma 디자인 구현해줘"
- Figma URL 제공 시 자동 활성화

## 작동 방식

```
1. 기존 컴포넌트 스캔 → 재사용 가능한 것 확인
2. Figma 디자인 분석 → 구조/스타일 파악
3. 매칭되는 컴포넌트 재사용
4. 없는 것만 새로 생성
```

## 핵심 규칙

### 1. 컴포넌트 재사용 우선
```
새 UI 요소 발견 → src/components/ 먼저 확인 → 있으면 재사용
```

### 2. 기존 스타일 시스템 활용
```
프로젝트의 CSS 변수, 디자인 토큰 확인 후 사용
- design-tokens.css
- tailwind.config.js
- 기존 컴포넌트 스타일
```

### 3. 새 컴포넌트 생성 시
```
- 기존 컴포넌트 패턴 따르기
- 프로젝트 컨벤션 준수
- 필요시 Storybook 스토리 생성
```

### 4. 아이콘 관리
```
새 아이콘 필요 시 → 기존 Icons 폴더에 추가
SVG 최적화 후 컴포넌트화
```

## 프로젝트 구조 자동 감지

스킬 실행 시 현재 프로젝트 구조를 분석합니다:

```bash
# 컴포넌트 위치 확인
src/components/  또는  components/

# 스타일 시스템 확인
- CSS Modules (.module.css)
- Tailwind CSS
- Styled Components
- 일반 CSS

# 아이콘 위치 확인
src/components/common/Icons/ 또는 유사 경로
```

## Figma MCP 연동

Figma MCP 서버가 연결되어 있으면:
1. Figma URL에서 직접 디자인 정보 추출
2. 레이어 구조, 스타일, 에셋 자동 분석
3. 코드 생성 자동화

MCP 없이도 사용 가능:
- 스크린샷/이미지 기반 구현
- 수동 디자인 명세 입력

## 작업 완료 후 검증

```bash
npm run build      # 빌드 확인
npm start          # 개발 서버 실행
npm run storybook  # Storybook 확인 (있는 경우)
```

## 사용 예시

```
사용자: 이 Figma 디자인 구현해줘 [URL]
Claude: [ftw 실행]
        1. 프로젝트 구조 분석...
        2. 기존 컴포넌트 확인: Button, Card 재사용 가능
        3. 새로 필요한 컴포넌트: ProductCard
        4. ProductCard.jsx 생성 중...
```

## 연동 스킬

- **gen-ai**: 컴포넌트에 이미지 필요 시 생성
- **error-doctor**: 빌드 에러 발생 시 분석
