# managed via salt, do not edit
function get_id {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
