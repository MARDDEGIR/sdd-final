#!/usr/bin/env bash
# @req SCI-TRACE-001
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REQUIREMENTS_FILE="${REPO_ROOT}/requirements.yaml"
EXIT_CODE=0

echo "========================================="
echo "  SDD Navigator Traceability Check"
echo "========================================="

VALID_IDS=$(grep "^  - id:" "${REQUIREMENTS_FILE}" | awk "{print \$3}")

UNANNOTATED=()
ORPHANS=()

for dir in charts ansible .github; do
  [ ! -d "${REPO_ROOT}/${dir}" ] && continue
  while IFS= read -r -d "" file; do
    [[ "$(basename $file)" == "Chart.lock" ]] && continue
    if ! grep -q "@req SCI-" "${file}" 2>/dev/null; then
      UNANNOTATED+=("${file#${REPO_ROOT}/}")
      echo "MISSING @req: ${file#${REPO_ROOT}/}"
    else
      while IFS= read -r req_id; do
        if ! echo "${VALID_IDS}" | grep -q "^${req_id}$"; then
          ORPHANS+=("${file#${REPO_ROOT}/}: ${req_id}")
          echo "ORPHAN @req ${req_id} in: ${file#${REPO_ROOT}/}"
        fi
      done < <(grep -oE "SCI-[A-Z]+-[0-9]+" "${file}" || true)
    fi
  done < <(find "${REPO_ROOT}/${dir}" -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.tpl" -o -name "*.sh" \) -print0)
done

echo ""
if [ ${#UNANNOTATED[@]} -eq 0 ] && [ ${#ORPHANS[@]} -eq 0 ]; then
  echo "ALL CHECKS PASSED"
else
  [ ${#UNANNOTATED[@]} -gt 0 ] && echo "UNANNOTATED: ${#UNANNOTATED[@]} files" && EXIT_CODE=1
  [ ${#ORPHANS[@]} -gt 0 ] && echo "ORPHANS: ${#ORPHANS[@]}" && EXIT_CODE=1
fi
exit ${EXIT_CODE}
