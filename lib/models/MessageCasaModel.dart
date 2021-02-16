class MessageCasaModel{

	String id;
	String name;
	bool active;
	DateTime created;
	MessageCasaModelType type;
	String message;
	String filepath;
	String testWord;
	MessageCasaModelState state;
	MessageCasaModelLocation location;
	MessageCasaModelExtras extras;
	List<dynamic> stats; // The type cannot be deduced,change the type

	MessageCasaModel({
		this.id,
		this.name,
		this.active,
		this.created,
		this.user,
		this.type,
		this.message,
		this.filepath,
		this.testWord,
		this.state,
		this.location,
		this.extras,
		this.stats,
	});

	MessageCasaModel copyWith({
		String name,
		bool active,
		DateTime created,
		DateTime user,
		MessageCasaModelType type,
		String message,
		String filepath,
		String testWord,
		MessageCasaModelState state,
		MessageCasaModelLocation location,
		MessageCasaModelExtras extras,
		List<dynamic> stats,
	}){
		return MessageCasaModel(
			name: name ?? this.name,
			active: active ?? this.active,
			created: created ?? this.created,
			user: user ?? this.user,
			type: type ?? this.type,
			message: message ?? this.message,
			filepath: filepath ?? this.filepath,
			testWord: testWord ?? this.testWord,
			state: state ?? this.state,
			location: location ?? this.location,
			extras: extras ?? this.extras,
			stats: stats ?? this.stats,
		);
	}

}

class MessageCasaModelStats{

	int clicks;
	double views;

	MessageCasaModelStats({
		this.clicks,
		this.views,
	});

	MessageCasaModelStats copyWith({
		int clicks,
		double views,
	}){
		return MessageCasaModelStats(
			clicks: clicks ?? this.clicks,
			views: views ?? this.views,
		);
	}

}

class MessageCasaModelLocation{

	String name;
	String street;
	String district;
	MessageCasaModelTool tool;
	MessageCasaModelExtras extras;
	String extraName;
	MessageCasaModelGeolocation geolocation;

	MessageCasaModelLocation({
		this.name,
		this.street,
		this.district,
		this.tool,
		this.extras,
		this.extraName,
		this.geolocation,
	});

	MessageCasaModelLocation copyWith({
		String name,
		String street,
		String district,
		MessageCasaModelTool tool,
		MessageCasaModelExtras extras,
		String extraName,
		MessageCasaModelGeolocation geolocation,
	}){
		return MessageCasaModelLocation(
			name: name ?? this.name,
			street: street ?? this.street,
			district: district ?? this.district,
			tool: tool ?? this.tool,
			extras: extras ?? this.extras,
			extraName: extraName ?? this.extraName,
			geolocation: geolocation ?? this.geolocation,
		);
	}

}

class MessageCasaModelGeolocation{

	double latitude;
	double longitude;
	String geohash;

	MessageCasaModelGeolocation({
		this.latitude,
		this.longitude,
		this.geohash,
	});

	MessageCasaModelGeolocation copyWith({
		double latitude,
		double longitude,
		String geohash,
	}){
		return MessageCasaModelGeolocation(
			latitude: latitude ?? this.latitude,
			longitude: longitude ?? this.longitude,
			geohash: geohash ?? this.geohash,
		);
	}

}

