<?php
$output = shell_exec('/acme.sh/acme.sh --list');
echo "<pre>$output</pre>";
?>