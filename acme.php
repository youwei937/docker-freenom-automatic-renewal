<?php
$output = shell_exec('/acme.sh/acme.sh --renew-all');
echo "<pre>$output</pre>";
?>