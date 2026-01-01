# Gen-AI (AI Image & Video Generation)

AI를 사용해 이미지와 영상을 생성하는 스킬입니다.

## 실행 방법

- `/gen-ai "프롬프트"`
- "이미지 만들어줘", "영상 생성해줘"

## 지원 모델

### 이미지 생성
| 모델 | 특징 | API |
|------|------|-----|
| **Imagen 4** | 고품질, 포토리얼 | Vertex AI |
| **Gemini 3 Pro Image** | 빠름, 한글 우수 | Gemini API |
| **GPT Image 1.5** | OpenAI, 스타일 다양 | OpenAI API |

### 영상 생성
| 모델 | 특징 | API |
|------|------|-----|
| **Veo 3.1** | Image-to-Video, 오디오 포함 | Vertex AI |

## 프롬프트 최적화

### 한국어 → 영어 자동 변환
| 한국어 | 영어 변환 |
|--------|-----------|
| 아이돌 | K-pop idol, realistic face, korean beauty |
| 웹툰 | Korean webtoon style, clean line art |
| 귀여운 | cute, chibi style |

### 스타일 자동 감지
| 트리거 | 감지 스타일 |
|--------|------------|
| 사람, 사진, 연예인 | Photorealistic |
| 그림, 일러스트, 캐릭터 | Digital Art |
| 귀여운, cute, 만화 | Anime/Cartoon |

### Negative Prompt 자동 추가

**Photorealistic:**
```
cartoon, 3d render, CGI, plastic skin, anime, blurry, bad anatomy
```

**Digital Art:**
```
photorealistic, photo, blurry, low quality, watermark
```

## API 파라미터

### 이미지 비율
- `1:1` - 정사각형
- `4:3` / `3:4` - 가로/세로
- `16:9` / `9:16` - 와이드/세로 와이드

### 영상 옵션
- **길이**: 4초, 6초, 8초
- **해상도**: 720p, 1080p
- **오디오**: 환경음/대화 자동 생성

## 배경 제거

이미지에서 배경을 제거하는 기능:

| 모드 | threshold | 용도 |
|------|-----------|------|
| 부드럽게 | 0 | 머리카락, 손가락 |
| 보통 | 0.3 | 일반적인 용도 |
| 선명하게 | 0.6 | 명확한 윤곽선 |

## 환경 변수

```bash
# Gemini API (권장)
GEMINI_API_KEY=AIza...

# Vertex AI (Imagen, Veo)
GOOGLE_PROJECT_ID=your-project-id
GOOGLE_APPLICATION_CREDENTIALS_JSON=[service-account]

# OpenAI (GPT Image)
OPENAI_API_KEY=sk-...

# Replicate (배경 제거)
REPLICATE_API_TOKEN=r8_...
```

## 사용 예시

```
사용자: 핑크색 바나나 만들어줘
Claude: [gen-ai 실행]
        모델: Gemini 3 Pro Image
        프롬프트 최적화: "A pink banana..."
        이미지 생성 중...
        [결과 이미지 반환]
```

```
사용자: 이 이미지로 영상 만들어줘
Claude: [gen-ai 실행]
        모델: Veo 3.1
        움직임 프롬프트 입력 대기...
```

## 에러 처리

| 에러 | 원인 | 해결 |
|------|------|------|
| `PERMISSION_DENIED` | API 키 권한 | 키 재발급 |
| `RESOURCE_EXHAUSTED` | 할당량 초과 | 대기 후 재시도 |
| `safety filter` | 콘텐츠 차단 | 프롬프트 수정 |
| `413 Too Large` | 이미지 크기 초과 | 압축 후 재시도 |

## 연동 스킬

- **ftw**: 컴포넌트용 이미지 생성
- **error-doctor**: 생성 에러 분석
