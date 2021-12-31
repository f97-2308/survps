<?php
$admin_url = rtrim("http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]", "/");

require_once "survps/UserManager.php";
require_once "survps/UserController.php";
require_once "survps/Firewall.php";
require_once "survps/FileManager.php";
require_once "survps/SQLManager.php";

$config = require "survps/config.php";
$userManager = new UserManager($config['files']['users']);
$firewall = new Firewall();

if (!$firewall->isAutenticated()) {
	header("HTTP/1.1 401 Authorization Required");
	header('WWW-Authenticate: Basic realm="Please login"');
	die();
}

if (!isset($_GET['action']))
	$_GET['action'] = '';

switch($_GET['action']) {

	case 'updatePassword':
		$controller = new UserController();
		$controller->updatePassword();
		break;

	case 'changePassword':
		$controller = new UserController();
		$controller->editPassword();
		break;

	case 'listUsers':
	default:
		$controller = new UserController();
		$controller->index();
}