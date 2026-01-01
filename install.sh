#!/bin/bash

# Claude Code Skills Installer
# 스킬 파일들을 ~/.claude/commands/에 설치합니다.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$SCRIPT_DIR/commands"
TARGET_DIR="$HOME/.claude/commands"

echo "🐋 Claude Code Skills Installer"
echo "================================"
echo ""

# 타겟 디렉토리 생성
if [ ! -d "$TARGET_DIR" ]; then
    echo "📁 Creating $TARGET_DIR..."
    mkdir -p "$TARGET_DIR"
fi

# 설치 방식 선택
echo "설치 방식을 선택하세요:"
echo "  1) 심볼릭 링크 (권장 - git pull로 자동 업데이트)"
echo "  2) 파일 복사 (독립적으로 수정 가능)"
echo ""
read -p "선택 [1/2]: " choice

case $choice in
    1)
        echo ""
        echo "📎 심볼릭 링크 생성 중..."
        for file in "$COMMANDS_DIR"/*.md; do
            filename=$(basename "$file")
            ln -sf "$file" "$TARGET_DIR/$filename"
            echo "  ✓ $filename"
        done
        echo ""
        echo "✅ 심볼릭 링크 설치 완료!"
        echo "   업데이트: git pull (자동 반영)"
        ;;
    2)
        echo ""
        echo "📋 파일 복사 중..."
        for file in "$COMMANDS_DIR"/*.md; do
            filename=$(basename "$file")
            cp "$file" "$TARGET_DIR/$filename"
            echo "  ✓ $filename"
        done
        echo ""
        echo "✅ 파일 복사 완료!"
        echo "   업데이트: git pull && ./install.sh"
        ;;
    *)
        echo "❌ 잘못된 선택입니다. 1 또는 2를 입력하세요."
        exit 1
        ;;
esac

echo ""
echo "================================"
echo "🎉 설치 완료!"
echo ""
echo "사용법:"
echo "  /commands     - 스킬 목록 확인"
echo "  /plan         - 프로젝트 계획 수립"
echo "  /next-page    - Next.js 페이지 생성"
echo "  /tw-component - Tailwind 컴포넌트 생성"
echo ""
