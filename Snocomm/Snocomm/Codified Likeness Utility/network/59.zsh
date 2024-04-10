#!/bin/zsh

EstacionDeAltaPotencia=(49719 106533 183682 183681 83897 106738 106535 83901 49740 106683 49797 106740 106554 151111 106623 106550 15147 106592 74941 10672 50814)

for ((i = 0; i < ${#EstacionDeAltaPotencia[@]}; i++)); do
        printf "%s\n" "${EstacionDeAltaPotencia[i]}"
done