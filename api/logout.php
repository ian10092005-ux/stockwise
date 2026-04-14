<?php

require_once '../includes/headers.php';

session_start();
session_unset();
session_destroy();

respond(['success' => true, 'message' => 'Logged out successfully.']);
