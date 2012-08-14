function populate_departments() {

}

function show_correspond_content(isShow, itemId, className) {
    $(document).ready(function () {
        $(className).hide();
    })
    if (isShow) {
        document.getElementById(itemId).style.display = 'block';

    } else {
        document.getElementById(itemId).style.display = 'none';
    }

}

function validate_check(isChecked, itemId, className) {
    $(document).ready(function () {
        $(".check_box_not_before").checked = false;
    })
    if (isChecked == true) {
        show_correspond_content(true, itemId, className)
    } else
        show_correspond_content(false, itemId, className);
}
