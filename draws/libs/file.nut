class File
{
	constructor(_path)
	{
		path = _path;
		line = 0;
	}
	
	function open(_mode)
	{
		mode = _mode;
		c_file = file(path, mode);
		opened = true;
	}
	
	function close()
	{
		mode = null;
		c_file.close();
		c_file = null;
		opened = false;
	}
	
	function exists()
	{
		try {
			local e_file = file(path, "r");
			e_file.close();
			return true;
		} catch(e) {
			return false;
		}
	}
	
	function readLine()
	{
		local r_line = "";
		local c_line = 0;
		
		while(!c_file.eos()) {
			local r_char = c_file.readn('b').tochar();
			
			if (r_char == "\n") {
				if (c_line < line) {
					c_line++;
					line = c_line;
					continue;
				}
				
				if (c_line == line)
					return r_line;
			}
			
			if(c_line == line)
				r_line += r_char;
		}
		
		if (c_line <= line)
			return r_line;

		return -1;
	}
	
	function writeLine(arg)
	{
		foreach(v in arg.tostring()) {
			c_file.writen(v, 'b');
		}
		c_file.writen('\n', 'b');
	}
	
	function setLine(val)
	{
		line = val;
	}
	
	function getLine()
	{
		return line;
	}
	
	c_file = null;
	path = null;
	line = null;
	mode = null;
	opened = false;
}