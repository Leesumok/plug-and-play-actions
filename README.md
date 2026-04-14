# Plug and Play Actions

포크 후 인증 정보만 설정하면 이슈 기반 자동화를 바로 사용할 수 있는 GitHub Actions 템플릿 저장소입니다.

이 저장소에는 `anthropics/claude-code-action@v1` 기반 워크플로우 2개가 포함되어 있습니다.

- 이슈 댓글에서 `@claude` 호출 시 응답
- `code-gen` 라벨이 붙은 이슈를 바탕으로 코드 생성 및 PR 생성

## 기능

### 1. Issue Comment 자동 응답

새 이슈 댓글이 생성되면 워크플로우가 실행되며, 기본적으로 `@claude` 가 포함된 댓글에 반응합니다.

- 이슈 요구사항을 보완하거나 정리
- 내용이 불명확하면 추가 질문 작성
- 단순 확인/감사 댓글에는 간단히 응답
- 항상 한국어로 응답

호출 문구나 응답 방식을 바꾸려면 [.github/workflows/issue-comment.yml](/Users/leesumok/Documents/workspace/plug-and-play-actions/.github/workflows/issue-comment.yml:1) 을 수정하면 됩니다.

- 호출 문구 변경: `with.trigger_phrase` 값을 원하는 문구로 수정 (default : `@claude`)
- 응답 기준 변경: `with.claude_args` 안의 `--append-system-prompt` 문구를 수정

현재 설정 예시:

```yaml
with:
  trigger_phrase: "@claude"
  claude_args: |
    --append-system-prompt "항상 한국어로 간결하게 답하고, issue comment를 분석해 적절히 행동하세요."
```

다음 경우에는 실행되지 않습니다.

- PR 댓글인 경우
- Bot 계정이 작성한 댓글인 경우

### 2. `code-gen` 라벨 기반 코드 생성

이슈에 정확히 `code-gen` 라벨이 추가되면 워크플로우가 실행됩니다.

- 이슈 요구사항 분석
- 저장소 패턴에 맞춰 코드 작성
- 필요 시 테스트 작성
- 브랜치 생성 및 PR 생성

브랜치 이름 규칙:

- 이슈 본문의 `## 브랜치` 섹션에 값이 있으면 그 이름 사용
- 비어 있으면 `feat/issue-{번호}-{간결한설명}` 형식으로 자동 생성

## 빠른 시작

### 1. 저장소 포크

이 저장소를 본인 계정으로 포크합니다.

### 2. GitHub Actions 활성화 확인

포크한 저장소에서 GitHub Actions가 비활성화되어 있다면 먼저 활성화합니다.

### 3. 인증 정보 설정

포크한 저장소에서 다음 경로로 이동합니다.

`Settings > Secrets and variables > Actions`

아래 둘 중 하나만 설정하는 것을 권장합니다.

#### Option A. OAuth Token

구독 플랜을 사용 중이라면 로컬에서 아래 명령으로 토큰을 발급할 수 있습니다.

```bash
claude setup-token
```

생성한 값을 다음 시크릿으로 저장합니다.

| Name | Value |
| --- | --- |
| `CLAUDE_CODE_OAUTH_TOKEN` | 발급한 토큰 |

#### Option B. API Key

Anthropic API Key를 사용한다면 다음 시크릿으로 저장합니다.

| Name | Value |
| --- | --- |
| `ANTHROPIC_API_KEY` | 발급한 API Key |

### 4. Workflow 권한 확인

다음 경로에서 `Read and write permissions` 가 활성화되어 있어야 합니다.

`Settings > Actions > General > Workflow permissions`

### 5. `code-gen` 라벨 확인

코드 생성 기능을 사용할 예정이라면 저장소에 `code-gen` 라벨이 있는지 확인합니다. 없으면 먼저 생성합니다.

## 사용 방법

### 이슈 댓글 자동 응답

1. 이슈를 생성합니다.
2. 이슈 본문 또는 요구사항과 관련된 댓글에 `@claude` 를 포함해 작성합니다.
3. 새 댓글이 생성되면 워크플로우가 실행되고, `trigger_phrase` 와 일치하면 Claude가 응답합니다.

주의:

- 이 워크플로우는 PR 댓글이 아니라 이슈 댓글에만 반응합니다.
- 포크 후 호출 문구를 바꾸고 싶다면 `.github/workflows/issue-comment.yml` 의 `trigger_phrase` 값을 한 번만 수정하면 됩니다.
- 응답 톤이나 처리 기준을 바꾸려면 같은 파일의 `claude_args` 안 `--append-system-prompt` 문구를 수정합니다.

### 코드 생성

1. 이슈를 생성합니다.
2. 가능하면 `Feature Request` 템플릿을 사용해 `## 목표`, `## 상세 요구사항`, `## 기술적 참고사항`, `## 브랜치`를 채웁니다.
3. 이슈에 `code-gen` 라벨을 추가합니다.
4. 워크플로우가 실행되면 Claude가 코드를 생성하고 PR 생성을 시도합니다.

## 저장소 구조

```text
.github/
├── ISSUE_TEMPLATE/
│   └── feature_request.md
└── workflows/
    ├── issue-comment.yml
    └── label-code-gen.yml
```

## 워크플로우 권한

워크플로우별로 필요한 권한은 다음과 같습니다.

- `issue-comment.yml`: `contents: read`, `id-token: write`, `issues: write`
- `label-code-gen.yml`: `contents: write`, `issues: write`, `pull-requests: write`

저장소 설정에서 `Read and write permissions` 가 꺼져 있으면 코드 생성 및 PR 생성이 실패할 수 있습니다.

## 자주 실패하는 경우

### 댓글에 응답하지 않는 경우

- 댓글이 PR이 아니라 이슈에 달린 댓글인지 확인
- 댓글에 `@claude` 또는 현재 설정된 `trigger_phrase` 가 포함되어 있는지 확인
- 인증 시크릿이 설정되어 있는지 확인
- Actions가 활성화되어 있는지 확인
- 워크플로우 실행 로그에서 실패 여부 확인

### `code-gen` 이 실행되지 않는 경우

- 라벨 이름이 정확히 `code-gen` 인지 확인
- 라벨이 이슈에 새로 추가된 이벤트인지 확인
- 저장소 권한이 `Read and write permissions` 인지 확인
- 인증 시크릿이 설정되어 있는지 확인

### 브랜치 이름이 예상과 다른 경우

- 이슈 본문에 `## 브랜치` 섹션이 있는지 확인
- 해당 섹션이 비어 있으면 자동 브랜치 이름이 사용됨

## 참고

- 봇이 남긴 댓글에는 다시 반응하지 않도록 설정되어 있습니다.
- API Key를 사용하면 사용량에 따라 비용이 발생할 수 있습니다.

## License

MIT
