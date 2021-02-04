w folderze GO należy stworzyć folder draws ręcznie np: g2o_server_win_x86\draws

you need to make folder "draws" in GO Server directory to make draw saver works

In config:
	<script src="examples/draws/cl_core.nut" type="client" />
	<script src="examples/draws/sv_core.nut" type="server" />
    where src means path to files mine was "examples/draws/cl_core.nut"

IMPORTANT
	include file.nut from libs folder
!L!echu #6598 for "support"