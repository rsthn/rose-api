<?php

chdir(__DIR__);

require_once ('vendor/autoload.php');

$_REQUEST['f'] = 'periodic';

Rose\Main::initialize();
