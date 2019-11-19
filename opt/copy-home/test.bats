#!/usr/bin/env bats

export TEST=true

programme=$BATS_TEST_DIRNAME/copy-home.sh
fixture_path=$BATS_TEST_DIRNAME/fixtures

shorten_fixture_path() { sed "s#$fixture_path#FIXTURE_PATH#g" <<<"$1"; }

@test 'Print usage' {
    run $programme -h
    [[ "${lines[0]}" = "    Usage: copy-home.sh [-h] <old_home_path> <new_home_path>" ]]
}

@test 'Copy all files' {
    run $programme $fixture_path/old_home $fixture_path/new_home_empty
    [[ "$(shorten_fixture_path "$output")" = "cp -r --preserve FIXTURE_PATH/old_home/foo.txt FIXTURE_PATH/new_home_empty/foo.txt
cp -r --preserve FIXTURE_PATH/old_home/.bar.txt FIXTURE_PATH/new_home_empty/.bar.txt" ]]
}

@test 'Recreate a file/directory in a new home if the same name file already exists' {
    run $programme $fixture_path/old_home $fixture_path/new_home_nonempty
    [[ "$(shorten_fixture_path "$output")" = "rm -rf FIXTURE_PATH/new_home_nonempty/foo.txt
cp -r --preserve FIXTURE_PATH/old_home/foo.txt FIXTURE_PATH/new_home_nonempty/foo.txt
cp -r --preserve FIXTURE_PATH/old_home/.bar.txt FIXTURE_PATH/new_home_nonempty/.bar.txt" ]]
}
