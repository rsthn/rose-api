<?php

chdir(__DIR__);
require_once ('vendor/autoload.php');

Rose\Main::cli (dirname(__FILE__), true);
try {
    Rose\Ext\Wind::run('wind/periodic.fn');
}
catch (\Exception $e) {
    \Rose\trace('[ERROR] [' . (new \Rose\DateTime()) . '] periodic: ' . $e->getMessage());
}
