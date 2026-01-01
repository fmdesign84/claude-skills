# Next.js API Route Generator

Next.js 14+ Route Handlers를 생성합니다.

## 실행 방법

- `/api-route users` 또는 "유저 API 만들어줘"

## Route Handler 패턴

### 기본 구조
```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const page = searchParams.get('page') || '1';
    const limit = searchParams.get('limit') || '10';

    // 데이터 조회 로직
    const users = await getUsers({ page: +page, limit: +limit });

    return NextResponse.json({
      success: true,
      data: users,
    });
  } catch (error) {
    console.error('[GET /api/users]', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch users' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // 유효성 검사
    const validated = userSchema.safeParse(body);
    if (!validated.success) {
      return NextResponse.json(
        { success: false, error: validated.error.flatten() },
        { status: 400 }
      );
    }

    // 생성 로직
    const user = await createUser(validated.data);

    return NextResponse.json(
      { success: true, data: user },
      { status: 201 }
    );
  } catch (error) {
    console.error('[POST /api/users]', error);
    return NextResponse.json(
      { success: false, error: 'Failed to create user' },
      { status: 500 }
    );
  }
}
```

### 동적 라우트
```tsx
// app/api/users/[id]/route.ts
import { NextRequest, NextResponse } from 'next/server';

interface Params {
  params: { id: string };
}

export async function GET(request: NextRequest, { params }: Params) {
  try {
    const user = await getUserById(params.id);

    if (!user) {
      return NextResponse.json(
        { success: false, error: 'User not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({ success: true, data: user });
  } catch (error) {
    return NextResponse.json(
      { success: false, error: 'Failed to fetch user' },
      { status: 500 }
    );
  }
}

export async function PATCH(request: NextRequest, { params }: Params) {
  try {
    const body = await request.json();
    const user = await updateUser(params.id, body);

    return NextResponse.json({ success: true, data: user });
  } catch (error) {
    return NextResponse.json(
      { success: false, error: 'Failed to update user' },
      { status: 500 }
    );
  }
}

export async function DELETE(request: NextRequest, { params }: Params) {
  try {
    await deleteUser(params.id);

    return NextResponse.json(
      { success: true, message: 'User deleted' },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      { success: false, error: 'Failed to delete user' },
      { status: 500 }
    );
  }
}
```

## 인증/미들웨어

### JWT 검증
```tsx
// lib/auth.ts
import { NextRequest } from 'next/server';
import { jwtVerify } from 'jose';

export async function verifyAuth(request: NextRequest) {
  const token = request.headers.get('authorization')?.split(' ')[1];

  if (!token) {
    return null;
  }

  try {
    const secret = new TextEncoder().encode(process.env.JWT_SECRET);
    const { payload } = await jwtVerify(token, secret);
    return payload;
  } catch {
    return null;
  }
}

// route.ts에서 사용
export async function GET(request: NextRequest) {
  const user = await verifyAuth(request);

  if (!user) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    );
  }

  // 인증된 사용자 로직
}
```

### 미들웨어
```tsx
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // 인증 체크
  const token = request.cookies.get('token')?.value;

  if (!token && request.nextUrl.pathname.startsWith('/api/protected')) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    );
  }

  return NextResponse.next();
}

export const config = {
  matcher: '/api/:path*',
};
```

## 파일 업로드

```tsx
// app/api/upload/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { writeFile } from 'fs/promises';
import { join } from 'path';

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData();
    const file = formData.get('file') as File;

    if (!file) {
      return NextResponse.json(
        { error: 'No file provided' },
        { status: 400 }
      );
    }

    // 파일 크기 검증
    if (file.size > 5 * 1024 * 1024) {
      return NextResponse.json(
        { error: 'File too large (max 5MB)' },
        { status: 400 }
      );
    }

    const bytes = await file.arrayBuffer();
    const buffer = Buffer.from(bytes);

    // 파일 저장 (또는 S3/Cloudinary 등에 업로드)
    const filename = `${Date.now()}-${file.name}`;
    const path = join(process.cwd(), 'public/uploads', filename);
    await writeFile(path, buffer);

    return NextResponse.json({
      success: true,
      url: `/uploads/${filename}`,
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Upload failed' },
      { status: 500 }
    );
  }
}
```

## 스트리밍 응답

```tsx
// app/api/stream/route.ts
export async function GET() {
  const encoder = new TextEncoder();

  const stream = new ReadableStream({
    async start(controller) {
      for (let i = 0; i < 10; i++) {
        await new Promise((resolve) => setTimeout(resolve, 500));
        controller.enqueue(encoder.encode(`data: ${i}\n\n`));
      }
      controller.close();
    },
  });

  return new Response(stream, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      Connection: 'keep-alive',
    },
  });
}
```

## 에러 핸들링 유틸

```tsx
// lib/api-utils.ts
import { NextResponse } from 'next/server';
import { ZodError } from 'zod';

export function handleApiError(error: unknown) {
  console.error(error);

  if (error instanceof ZodError) {
    return NextResponse.json(
      { success: false, error: error.flatten() },
      { status: 400 }
    );
  }

  if (error instanceof Error) {
    return NextResponse.json(
      { success: false, error: error.message },
      { status: 500 }
    );
  }

  return NextResponse.json(
    { success: false, error: 'Internal server error' },
    { status: 500 }
  );
}

// 사용
export async function POST(request: NextRequest) {
  try {
    // 로직
  } catch (error) {
    return handleApiError(error);
  }
}
```

## Route 설정

```tsx
// 캐싱 비활성화
export const dynamic = 'force-dynamic';

// 런타임 설정
export const runtime = 'edge'; // 또는 'nodejs'

// 최대 실행 시간 (초)
export const maxDuration = 30;
```

## 체크리스트

- [ ] HTTP 메서드별 핸들러 분리
- [ ] 입력 유효성 검사 (Zod)
- [ ] 에러 핸들링 & 로깅
- [ ] 인증/권한 검사
- [ ] 응답 형식 통일
- [ ] 타입 안전성
