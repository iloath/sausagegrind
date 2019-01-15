//SausageGrind v1.0 by iloath
script "sausagegrind.ash";
notify iloath;

int make_sausage(int count_lim, int paste_lim)
{
	if ((item_amount($item[Kramco Sausage-o-Matic&trade;]) <= 0) && !(have_equipped($item[Kramco Sausage-o-Matic&trade;])))
	{
		print("No grinder");
		return -1;
	}
	int count = 0;
	while(count < count_lim){
		int paste = -1;
		string page = visit_url("inventory.php?action=grind");
		if (page.contains_text("You currently have 0 magical sausage casings.")) {
			print("No casing for next sausage", "red");
			visit_url("choice.php?whichchoice=1339&pwd=" + my_hash() + "&option=3&sumbit=Nevermind!",true);
			return count;
		}
		matcher match_paste = create_matcher("It looks like your grinder needs (\\d+\\,?\\d+) of the" , page);
		if(match_paste.find()) {
			paste = match_paste.group(1).to_int();
			print("meat: "+paste);
		}
		if(paste > 0) {
			if(paste > min(paste_lim, my_meat())){
				print("next sausage too expensive");
				visit_url("choice.php?whichchoice=1339&pwd=" + my_hash() + "&option=3&sumbit=Nevermind!",true);
				return count;
			}
			paste = ceil(to_float(paste) / 10.0);
			print("meat pastes: "+paste,"blue");
			visit_url("craft.php?action=makepaste&pwd=" + my_hash() + "&whichitem=25&qty=" + paste + "&sumbit=Make",true);
			visit_url("choice.php?whichchoice=1339&pwd=" + my_hash() + "&option=1&iid=25&qty=" + paste + "&sumbit=Grind!",true);
		}
		visit_url("choice.php?whichchoice=1339&pwd=" + my_hash() + "&option=2",true);
		count = count + 1;
	}
	print("Made enough ("+ count +") sausages","blue");
	visit_url("choice.php?whichchoice=1339&pwd=" + my_hash() + "&option=3&sumbit=Nevermind!",true);
	return count;
}

void main(int count_lim, int meat_lim) {
	make_sausage(count_lim, meat_lim);
}
