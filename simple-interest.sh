
---

### `simple-intersest.sh`
```bash
#!/usr/bin/env bash
# simple-intersest.sh
# Calculate Simple Interest
# Usage:
#   ./simple-intersest.sh            # interactive mode
#   ./simple-intersest.sh P R T      # P=principal, R=rate(% per year), T=time (years)

set -euo pipefail

print_usage() {
  cat <<EOF
Usage:
  $0            # interactive
  $0 P R T      # non-interactive: principal rate(%) time(years)

Example:
  $0 1000 5 2
EOF
}

calc_si() {
  # Using bc for floating point math
  local P=$1 R=$2 T=$3
  # simple interest = P * R * T / 100
  interest=$(printf "%s * %s * %s / 100\n" "$P" "$R" "$T" | bc -l)
  total=$(printf "%s + %s\n" "$P" "$interest" | bc -l)
  # format to 2 decimal places
  interest_f=$(printf "%.2f" "$interest")
  total_f=$(printf "%.2f" "$total")
  echo "Principal : $P"
  echo "Rate (%)  : $R"
  echo "Time (yrs): $T"
  echo "Interest  : $interest_f"
  echo "Total     : $total_f"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_usage
  exit 0
fi

if [[ $# -eq 3 ]]; then
  P="$1"; R="$2"; T="$3"
  calc_si "$P" "$R" "$T"
  exit 0
fi

# interactive mode
echo "Simple Interest Calculator"
read -rp "Principal (P): " P
read -rp "Rate (%) (R): " R
read -rp "Time (years) (T): " T

# basic validation: ensure numbers
re='^[0-9]+([.][0-9]+)?$'
if ! [[ $P =~ $re ]] || ! [[ $R =~ $re ]] || ! [[ $T =~ $re ]]; then
  echo "Error: Please enter numeric values (integers or decimals)."
  exit 1
fi

calc_si "$P" "$R" "$T"
