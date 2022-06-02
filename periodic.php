<?php

chdir(__DIR__);
require_once ('vendor/autoload.php');

Rose\Main::cli (dirname(__FILE__), true);

Rose\Ext\Wind::run('rcore/periodic.fn');
