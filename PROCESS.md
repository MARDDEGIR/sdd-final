# PROCESS.md

## 1. Tools Used
- Claude (claude.ai) - primary development tool
- Linux terminal (Ubuntu 24 in VirtualBox)

## 2. Key Decisions
- Bitnami PostgreSQL subchart - production-ready defaults, existingSecret support
- Umbrella chart with subcharts - separates API and frontend concerns
- Environment variable for DB password - never committed to files

## 3. Self-Assessment

| Pillar | Coverage |
|--------|----------|
| Traceability | PASS - all files annotated, check-traceability.sh enforces |
| DRY | PASS - _helpers.tpl, all values in values.yaml |
| Deterministic Enforcement | PASS - CI runs helm lint, kubeconform, ansible-lint, yamllint, traceability |
| Parsimony | PASS - minimal charts, single-purpose roles |
