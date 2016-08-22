// ==UserScript==
// @name        SpellDamage class spells helper
// @namespace   SpellDamage
// @description Helps to generate list of class spell ids
// @include     http://ru.wowhead.com/class=*
// @version     1
// @grant       none
// ==/UserScript==

function $(element)
{
	if(element === null)
		return null;

	var obj = {};
	obj.obj = element;
	obj.get = function (nodeName, position = 1, noWarning = false)
	{
		var childs = element.childNodes;
		var match = 0;
		for(var i = 0; i < childs.length; ++i)
			if(childs[i].nodeName == nodeName)
			{
				match++;
				if(match == position)
					return childs[i];
			}
		if(!noWarning)
		{
			console.log("in '" + element.nodeName + "' object no child '" + nodeName + "'");
			obj.printChilds();
		}
		return null;
	};
	obj.$ = function (nodeName)
	{
		return $( obj.get(nodeName) );
	};
	obj.list = function (nodeName)
	{
		var ret = [];
		var childs = element.childNodes;
		for(var i = 0; i < childs.length; ++i)
			if(childs[i].nodeName == nodeName)
				ret.push(childs[i]);
		if(ret.length == 0)
			console.log("in '" + element.nodeName + "' object no childs '" + nodeName + "'");
		return ret;
	};
	obj.printChilds = function()
	{
		var childs = element.childNodes;
		var list = [];
		for(var i = 0; i < childs.length; ++i)
			list.push(childs[i].nodeName + " " + childs[i].className);
		console.log(list);
	};
	return obj;
}

var rows = [];
var addedRows = [];
function compute()
{
	rows = [];
	addedRows = [];

	var textarea = document.getElementsByClassName("comment-editbox")[0];
	var update = function()
	{
		addedRows.sort(function(l, r){
			if(l < r)
				return -1;
			else if(l > r)
				return 1;
			return 0;
		});
		var text = "";
		for(var i = 0; i < addedRows.length; ++i)
			text += rows[addedRows[i]].id + ",\t#" + rows[addedRows[i]].text + "\n";
		textarea.value = text;
	};
	textarea.value = "";

	var table = $(document.getElementsByClassName("listview-mode-default")[0]).$("TBODY").list("TR");
	for(var i = 0; i < table.length; ++i)
	{
		var columns = $(table[i]).list("TD");
		var text = $(columns[2]).$("DIV").$("A").obj.innerHTML;
		var spellId = $(columns[2]).$("DIV").$("A").obj.href.match(/\d+/i);
		rows.push({id: spellId, text: text});

		var button = document.createElement("A");
		button.innerHTML = "Add";
		button.i = i;
		button.onclick = function()
		{
			if(this.innerHTML === "Add")
			{
				this.innerHTML = "Remove";
				addedRows.push(this.i);
				update();
			}
			else
			{
				this.innerHTML = "Add";
				var i = addedRows.indexOf(this.i);
				console.log(i);
				if(i !== -1)
				{
					addedRows.splice(i, 1);
					update();
				}
			}
		};
		columns[4].innerHTML = "";
		columns[4].appendChild(button);

		table[i].onclick = null;
	}
}

function start()
{
	try
	{
		compute();

		var updateButton = document.createElement("A");
		updateButton.innerHTML = "Update";
		updateButton.onclick = compute;
		document.getElementsByClassName("listview-withselected")[0].appendChild(updateButton);

		console.log("SpellDamage script finished");
	}
	catch(error)
	{
		console.log("SpellDamage helper script error:\n" + error.message);
	}
}
window.onload = function() { setTimeout(start, 200); };