file_name=$1
benchmark_name=${file_name%%-*}
path_to_file=$benchmark_name/$file_name
scp -P 6060 debian@pc012170.fit.vutbr.cz:smt-bench/bench/$file_name $path_to_file

GIT_COMMIT=$(ggrep -m 1 -Po '.{7}(?=-result)' $path_to_file)
sed -i '' "s/$GIT_COMMIT-result/result/g" $path_to_file
sed -i '' "s/z3-noodler/z3-noodler-$GIT_COMMIT/g" $path_to_file

# ls $benchmark_name/*.tasks | sed "s/-underapprox/underapprox/g" | sort -t- -k 5 | sed "s/underapprox/-underapprox/g" | xargs cat | python3 pyco_proc --csv > $benchmark_name/to120.csv
ls $benchmark_name/*.tasks | sed "s/2023/@/g" | sort -t@ -k 2 | sed "s/@/2023/g" | xargs cat | python3 pyco_proc --csv > $benchmark_name/to120.csv
git add $path_to_file $benchmark_name/to120.csv
git commit -m "z3-noodler-$GIT_COMMIT on $benchmark_name"
