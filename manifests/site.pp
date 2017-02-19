node default { }
if (hiera('additional_classes') != false) {
    hiera_include('additional_classes')
}
