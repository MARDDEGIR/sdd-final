#!/usr/bin/env bash
# @req SCI-TRACE-001

REPO_ROOT="${REPO_ROOT:-$(pwd)}"
REQUIREMENTS_FILE="${REPO_ROOT}/requirements.yaml"

echo "Repo root: ${REPO_ROOT}"
echo "Requirements: ${REQUIREMENTS_FILE}"

if [ ! -f "${REQUIREMENTS_FILE}" ]; then
  echo "ERROR: requirements.yaml not found"
  exit 1
fi

echo "Found requirements.yaml"

VALID_IDS=$(grep "  - id:" "${REQUIREMENTS_FILE}" | sed "s/.*id: //" | tr -d " ")
echo "Valid IDs: ${VALID_IDS}"

EXIT_CODE=0
UNANNOTATED=""

for dir in charts ansible .github; do
  if [ ! -d "${REPO_ROOT}/${dir}" ]; then
    continue
  fi
  for file in $(find "${REPO_ROOT}/${dir}" -type f -name "*.yaml" -o -name "*.yml" -o -name "*.tpl" -o -name "*.sh" 2>/dev/null); do
    base=$(basename "${file}")
    if [ "${base}" = "Chart.lock" ]; then
      continue
    fi
    if ! grep -q "@req SCI-" "${file}" 2>/dev/null; then
      echo "MISSING @req: ${file#${REPO_ROOT}/}"
      UNANNOTATED="yes"
      EXIT_CODE=1
    fi
  done
done

if [ ${EXIT_CODE} -eq 0 ]; then
  echo "ALL CHECKS PASSED"
fi

exit ${EXIT_CODE}
