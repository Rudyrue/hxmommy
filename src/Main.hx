using StringTools;

import haxe.Json;

typedef MommySettings = {
	var CAREGIVER:String;
	var THEY:String;
	var THEM:String;
	var THEIR:String;
	var THEIRS:String;
	var THEIRSELF:String;
    var SWEETIE:String;

    var prefix:String;
    var suffix:String;
    var capitalize:Bool;
    var colour:Int;

    var compliments:Array<String>;
	var ?extraCompliments:Array<String>;

    var encouragements:Array<String>;
	var ?extraEncouragements:Array<String>;
}

class Main {
	public static function main() {
        if (Sys.systemName() != "Windows") {
            Sys.println("sorry honey, i only work on windows for now~");
            Sys.exit(1);
            return;
        }

		loadSettings();

		var args:Array<String> = Sys.args().copy();

		switch (args[0]) {
			case 'about':
				print('this is a port of "mommy" by FWDekker');
				print('ported by Rudyrue');
				Sys.exit(1);

			default: 
				var exitCode:Int = Sys.command(args.join(' '));
				mommy(exitCode);
		}
	}

	static var settings:MommySettings;
	static function loadSettings() {
		var newSettings:MommySettings = loadDummySettings();
		var path:String = '${Sys.getEnv('USERPROFILE')}/mommySettings.json';
		if (!sys.FileSystem.exists(path)) {
			settings = newSettings;
			return;
		}

		var jsonData:MommySettings = cast Json.parse(sys.io.File.getContent(path));

		for (field in Reflect.fields(newSettings)) {
			if (!Reflect.hasField(jsonData, field)) continue;

			Reflect.setField(newSettings, field, Reflect.field(jsonData, field));
		}

		if (jsonData.extraCompliments != null) newSettings.compliments.concat(jsonData.extraCompliments);
		if (jsonData.extraEncouragements != null) newSettings.encouragements.concat(jsonData.extraEncouragements);

		settings = newSettings;
	}

	static function mommy(exitCode:Int = -1):Void {
		var list:Array<String> = switch exitCode {
			case 0: settings.compliments;
			case 1, -1: settings.encouragements;

			default: settings.compliments;
		}

		var finalText:String = format(list[Math.floor(Std.random(list.length - 1))]);
		print(finalText);
	}

    static function format(string:String):String {
        for (i in ['#CAREGIVER', '#SWEETIE', '#THEY', '#THEM', '#THEIR', '#THEIRS', '#THEIRSELF']) {
            if (!string.contains(i)) continue;

			string = string.replace(i, Reflect.field(settings, i.replace('#', '')));
        }

        return '${settings.prefix}$string${settings.suffix}';
    }

	static function print(text:String):Void {
		Sys.println('\033[${0};${settings.colour}m$text\033[${0};${37}m');
	}

	static function loadDummySettings():MommySettings {
		return {
			CAREGIVER: 'mommy',
			THEY: 'she',
			THEM: 'her',
			THEIR: 'her',
			THEIRS: 'hers',
			THEIRSELF: 'herself',
			
			SWEETIE: "girl",
			prefix: "",
			suffix: "~",

			capitalize: false,
			colour:  95, // utilizes ansi codes, is magenta by default

			compliments: [
				// generic~
				"*pets your head*",
				"amazing work as always",
				"#CAREGIVER loves you, honey",

				// good (X)~
				"good #SWEETIE",
				"good job, #SWEETIE",
				"that's a good #SWEETIE",
				"who's my good #SWEETIE",

				// proud~
				"#CAREGIVER is very proud of you",
				"#CAREGIVER is so proud of you",
				"#CAREGIVER knew you could do it",
				"#CAREGIVER loves you, you are doing amazing",

				// compliment~
				"#CAREGIVER's #SWEETIE is so smart",

				// reward~
				"#CAREGIVER thinks you deserve a special treat for that",
				"my little #SWEETIE deserves a big fat kiss for that"
			],

			encouragements: [
				// trust~
				"#CAREGIVER believes in you",
				"#CAREGIVER knows you'll get there",
				"#CAREGIVER knows #THEIR little #SWEETIE can do better",
				"just know that #CAREGIVER still loves you",

				// consolation~
				"don't worry, it'll be alright",
				"it's okay to make mistakes",
				"#CAREGIVER knows it's hard, but it will be okay",

				// fallback~
				"#CAREGIVER is always here for you",
				"#CAREGIVER is always here for you if you need #THEM",
				"come here, sit on my lap while we figure this out together",

				// encouragement~
				"never give up, my love",
				"just a little further, #CAREGIVER knows you can do it",
				"#CAREGIVER knows you'll get there, don't worry about it",

				// clean up~
				"did #CAREGIVER's #SWEETIE make a big mess"
			]
		}
	}
}
