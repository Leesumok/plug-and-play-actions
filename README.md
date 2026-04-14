# Plug and Play Actions

포크하면 바로 사용할 수 있는 GitHub Actions + Claude Code Action 통합 레포지토리입니다.

## 기능

### 1. Issue Comment 자동 응답
Issue에 comment가 달리면 Claude가 자동으로 분석하여:
- Issue 내용을 수정/보완하거나
- 불명확한 부분에 대해 추가 질의를 답글로 작성합니다

### 2. 라벨 기반 Code Generation
Issue에 `code-gen` 라벨을 붙이면 Claude가:
- Issue 내용을 분석하여 코드를 생성하고
- Feature 브랜치를 만들어 PR을 자동 생성합니다

## 시작하기

### 1. 레포지토리 포크
이 레포지토리를 포크합니다.

### 2. 인증 설정 (둘 중 하나 선택)

포크한 레포지토리에서 **Settings** > **Secrets and variables** > **Actions** 이동 후:

**방법 A: OAuth Token (Pro/Max 구독자 추천)**
- 별도 API 비용 없이 구독 플랜으로 사용
1. 로컬 터미널에서 `claude setup-token` 실행
2. 생성된 토큰을 복사
3. **New repository secret** > Name: `CLAUDE_CODE_OAUTH_TOKEN` > Value: 복사한 토큰

**방법 B: API Key**
- 사용한 만큼 과금
1. [Anthropic Console](https://console.anthropic.com/)에서 API Key 발급
2. **New repository secret** > Name: `ANTHROPIC_API_KEY` > Value: 발급받은 API Key

> 둘 다 설정하면 OAuth Token이 우선 사용됩니다.

### 3. 사용하기

**Issue Comment 자동 응답:**
- Issue를 생성하고 comment를 달면 Claude가 자동으로 응답합니다

**Code Generation:**
1. Issue를 생성하고 요구사항을 상세히 작성합니다
2. Issue에 `code-gen` 라벨을 추가합니다
3. Claude가 코드를 생성하고 PR을 만듭니다

## 워크플로우 구조

```
.github/workflows/
├── issue-comment.yml      # Issue comment 자동 응답
└── label-code-gen.yml     # 라벨 기반 코드 생성
```

## 필요 권한

워크플로우가 정상 동작하려면 다음 권한이 필요합니다:
- `contents: write` — 코드 생성 및 브랜치 생성
- `issues: write` — Issue 수정 및 comment 작성
- `pull-requests: write` — PR 생성

> GitHub Actions는 기본적으로 이 권한들을 제공합니다.
> Settings > Actions > General > Workflow permissions에서 "Read and write permissions"이 활성화되어 있는지 확인하세요.

## 주의사항

- 봇이 생성한 comment에는 자동 응답하지 않습니다 (무한루프 방지)
- `ANTHROPIC_API_KEY`가 설정되지 않으면 워크플로우가 실패합니다
- API 사용량에 따라 비용이 발생할 수 있습니다
