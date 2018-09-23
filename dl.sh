readonly working_dir=$(cd "$(dirname "$0")" && pwd)

curl "https://api.glitch.com/project/download/?authorization=$GLITCH_API_TOKEN&projectId=$GLITCH_PROJECT_ID" | tar zx -C .

glitch_ignore=(
    .git
    .data
    .env
)

grep_arg=
for pattern in "${glitch_ignore[@]}"; do
    grep_arg+=" -e $pattern"
done

find "app" -type f | while read f; do
    if ! echo $f | grep -sq $grep_arg; then
        dist=$(echo $f | sed -E "s/app\///")
        cp $f $dist
    fi
done

rm -rf ./app
