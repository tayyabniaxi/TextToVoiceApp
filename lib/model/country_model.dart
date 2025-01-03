class Language {
  final String code;
  final String name;
  final List<Country> countries;

  const Language({
    required this.code,
    required this.name,
    required this.countries,
  });
}

class Country {
  final String code;
  final String name;
  final String voiceName;

  final String countryPic;
  final String profilePic;
  const Country({
    required this.code,
    required this.name,
    required this.voiceName,
    required this.countryPic,
    required this.profilePic,
  });
}

const List<Language> defaultLanguages = [
  Language(
    code: 'en',
    name: 'English',
    countries: [
      Country(
          code: 'US',
          name: 'United States',
          voiceName: "Nate",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'GB',
          name: 'United Kingdom',
          voiceName: "Amy",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15894901/pexels-photo-15894901/free-photo-of-man-with-mustache-and-beard.png?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'AU',
          name: 'Australia',
          voiceName: "Nicole",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/11323366/pexels-photo-11323366.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'IN',
          name: 'India',
          voiceName: "Raveena",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/11211913/pexels-photo-11211913.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CA',
          name: 'Canada',
          voiceName: "Joanna",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/4903358/pexels-photo-4903358.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'NZ',
          name: 'New Zealand',
          voiceName: "Kendra",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16778679/pexels-photo-16778679/free-photo-of-portrait-of-a-young-woman-in-a-baseball-cap.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'IE',
          name: 'Ireland',
          voiceName: "Ivy",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/20519321/pexels-photo-20519321/free-photo-of-man-with-tattoos-wearing-a-white-t-shirt-posing-with-arms-crossed.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'ZA',
          name: 'South Africa',
          voiceName: "Joey",
          countryPic:
              "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/10765194/pexels-photo-10765194.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'es',
    name: 'Spanish',
    countries: [
      Country(
          code: 'ES',
          name: 'Spain',
          voiceName: "Conchita",
          countryPic:
              "https://images.pexels.com/photos/16034036/pexels-photo-16034036/free-photo-of-the-national-flag-of-austria.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/26571331/pexels-photo-26571331/free-photo-of-man-crossing-arms-against-urban-background.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'MX',
          name: 'Mexico',
          voiceName: "Mia",
          countryPic:
              "https://images.pexels.com/photos/16034036/pexels-photo-16034036/free-photo-of-the-national-flag-of-austria.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/28222836/pexels-photo-28222836/free-photo-of-portrait-of-a-guy-with-a-tattoo.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      // Country(
      //     code: 'AR',
      //     name: 'Argentina',
      //     voiceName: "Lupe",
      //     countryPic: "",
      //     profilePic:
      //         "https://images.pexels.com/photos/8183929/pexels-photo-8183929.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CO',
          name: 'Colombia',
          voiceName: "Penelope",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/10761532/pexels-photo-10761532.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'PE',
          name: 'Peru',
          voiceName: "Miguel",
          countryPic:
              "https://images.pexels.com/photos/16034036/pexels-photo-16034036/free-photo-of-the-national-flag-of-austria.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/29138671/pexels-photo-29138671/free-photo-of-stylish-tattooed-man-in-red-t-shirt.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'VE',
          name: 'Venezuela',
          voiceName: "Enrique",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/14241737/pexels-photo-14241737.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CL',
          name: 'Chile',
          voiceName: "Francisco",
          countryPic:
              "https://images.pexels.com/photos/16034036/pexels-photo-16034036/free-photo-of-the-national-flag-of-austria.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/14241737/pexels-photo-14241737.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      // Country(
      //     code: 'EC',
      //     name: 'Ecuador',
      //     voiceName: "Gerardo",
      //     countryPic:
      //         "https://images.pexels.com/photos/16034036/pexels-photo-16034036/free-photo-of-the-national-flag-of-austria.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      //     profilePic:
      //         "https://images.pexels.com/photos/10189529/pexels-photo-10189529.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'fr',
    name: 'French',
    countries: [
      Country(
          code: 'FR',
          name: 'France',
          voiceName: "Celine",
          countryPic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/11211915/pexels-photo-11211915.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CA',
          name: 'Canada',
          voiceName: "Chantal",
          countryPic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/17164029/pexels-photo-17164029/free-photo-of-portrait-of-man-in-red-t-shirt.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
      Country(
          code: 'BE',
          name: 'Belgium',
          voiceName: "Mathieu",
          countryPic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16780715/pexels-photo-16780715/free-photo-of-young-bearded-man-in-glasses.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CH',
          name: 'Switzerland',
          voiceName: "Chantal",
          countryPic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'LU',
          name: 'Luxembourg',
          voiceName: "Celine",
          countryPic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'SN',
          name: 'Senegal',
          voiceName: "Chantal",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'MG',
          name: 'Madagascar',
          voiceName: "Lucia",
          countryPic:
              "https://images.pexels.com/photos/5781917/pexels-photo-5781917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'de',
    name: 'German',
    countries: [
      Country(
          code: 'DE',
          name: 'Germany',
          voiceName: "Marlene",
          countryPic:
              "https://images.pexels.com/photos/968308/pexels-photo-968308.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'AT',
          name: 'Austria',
          voiceName: "Hans",
          countryPic:
              "https://images.pexels.com/photos/968308/pexels-photo-968308.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CH',
          name: 'Switzerland',
          voiceName: "Marlene",
          countryPic:
              "https://images.pexels.com/photos/968308/pexels-photo-968308.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic: ""),
      Country(
          code: 'LU',
          name: 'Luxembourg',
          voiceName: "Marlene",
          countryPic:
              "https://images.pexels.com/photos/968308/pexels-photo-968308.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'LI',
          name: 'Liechtenstein',
          voiceName: "Marlene",
          countryPic:
              "https://images.pexels.com/photos/968308/pexels-photo-968308.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'it',
    name: 'Italian',
    countries: [
      Country(
          code: 'IT',
          name: 'Italy',
          voiceName: "Giorgio",
          countryPic:
              "https://images.pexels.com/photos/16033964/pexels-photo-16033964/free-photo-of-the-national-flag-of-mexico.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      // Country(
      //     code: 'CH',
      //     name: 'Switzerland',
      //     voiceName: "Giorgio",
      //     countryPic: "",
      //     profilePic:
      //         "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'SM',
          name: 'San Marino',
          voiceName: "Giorgio",
          countryPic:
              "https://images.pexels.com/photos/16033964/pexels-photo-16033964/free-photo-of-the-national-flag-of-mexico.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'VA',
          name: 'Vatican City',
          voiceName: "Giorgio",
          countryPic:
              "https://images.pexels.com/photos/16033964/pexels-photo-16033964/free-photo-of-the-national-flag-of-mexico.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'pt',
    name: 'Portuguese',
    countries: [
      Country(
          code: 'PT',
          name: 'Portugal',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/16033966/pexels-photo-16033966/free-photo-of-the-national-flag-of-serbia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'BR',
          name: 'Brazil',
          voiceName: "Vitoria",
          countryPic:
              "https://images.pexels.com/photos/16033966/pexels-photo-16033966/free-photo-of-the-national-flag-of-serbia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'AO',
          name: 'Angola',
          voiceName: "Amalia",
          countryPic:
              "https://images.pexels.com/photos/16033966/pexels-photo-16033966/free-photo-of-the-national-flag-of-serbia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15180292/pexels-photo-15180292/free-photo-of-photo-of-a-young-man-in-a-white-t-shirt-and-a-bandana-standing-outside.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'MZ',
          name: 'Mozambique',
          voiceName: "Amalia",
          countryPic:
              "https://images.pexels.com/photos/16033966/pexels-photo-16033966/free-photo-of-the-national-flag-of-serbia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'GW',
          name: 'Guinea-Bissau',
          voiceName: "Amalia",
          countryPic:
              "https://images.pexels.com/photos/16033966/pexels-photo-16033966/free-photo-of-the-national-flag-of-serbia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'ru',
    name: 'Russian',
    countries: [
      Country(
          code: 'RU',
          name: 'Russia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15652222/pexels-photo-15652222/free-photo-of-the-national-flag-of-bolivia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'BY',
          name: 'Belarus',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15652222/pexels-photo-15652222/free-photo-of-the-national-flag-of-bolivia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'KZ',
          name: 'Kazakhstan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15652222/pexels-photo-15652222/free-photo-of-the-national-flag-of-bolivia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'KG',
          name: 'Kyrgyzstan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15652222/pexels-photo-15652222/free-photo-of-the-national-flag-of-bolivia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'zh',
    name: 'Chinese',
    countries: [
      Country(
          code: 'CN',
          name: 'China',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483517/pexels-photo-15483517/free-photo-of-the-national-flag-of-finland.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'TW',
          name: 'Taiwan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483517/pexels-photo-15483517/free-photo-of-the-national-flag-of-finland.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'SG',
          name: 'Singapore',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483517/pexels-photo-15483517/free-photo-of-the-national-flag-of-finland.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'MY',
          name: 'Malaysia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483517/pexels-photo-15483517/free-photo-of-the-national-flag-of-finland.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'ar',
    name: 'Arabic',
    countries: [
      Country(
          code: 'SA',
          name: 'Saudi Arabia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'AE',
          name: 'United Arab Emirates',
          voiceName: "Ines",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'EG',
          name: 'Egypt',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'IQ',
          name: 'Iraq',
          voiceName: "Ines",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'JO',
          name: 'Jordan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'LB',
          name: 'Lebanon',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'OM',
          name: 'Oman',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'QA',
          name: 'Qatar',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483696/pexels-photo-15483696/free-photo-of-flag-of-saudi-arabia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7993560/pexels-photo-7993560.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'ja',
    name: 'Japanese',
    countries: [
      Country(
          code: 'JP',
          name: 'Japan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7793131/pexels-photo-7793131.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
    ],
  ),
  Language(
    code: 'ko',
    name: 'Korean',
    countries: [
      Country(
          code: 'KR',
          name: 'South Korea',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7793131/pexels-photo-7793131.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
      Country(
          code: 'KP',
          name: 'North Korea',
          voiceName: "Ines",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/7793131/pexels-photo-7793131.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
    ],
  ),
  Language(
    code: 'hi',
    name: 'Hindi',
    countries: [
      Country(
          code: 'IN',
          name: 'India',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7793131/pexels-photo-7793131.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
      Country(
          code: 'FJ',
          name: 'Fiji',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/7793131/pexels-photo-7793131.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
    ],
  ),
  Language(
    code: 'nl',
    name: 'Dutch',
    countries: [
      Country(
          code: 'NL',
          name: 'Netherlands',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/1438081/pexels-photo-1438081.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'BE',
          name: 'Belgium',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/1438081/pexels-photo-1438081.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'SR',
          name: 'Suriname',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483709/pexels-photo-15483709/free-photo-of-flag-of-brazil.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/1438081/pexels-photo-1438081.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'sv',
    name: 'Swedish',
    countries: [
      Country(
          code: 'SE',
          name: 'Sweden',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/27165133/pexels-photo-27165133/free-photo-of-flag-of-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/4959374/pexels-photo-4959374.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'FI',
          name: 'Finland',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/27165133/pexels-photo-27165133/free-photo-of-flag-of-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/4959374/pexels-photo-4959374.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'no',
    name: 'Norwegian',
    countries: [
      Country(
          code: 'NO',
          name: 'Norway',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651884/pexels-photo-15651884/free-photo-of-the-national-flag-of-norway.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/4959374/pexels-photo-4959374.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'da',
    name: 'Danish',
    countries: [
      Country(
          code: 'DK',
          name: 'Denmark',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651884/pexels-photo-15651884/free-photo-of-the-national-flag-of-norway.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/4959374/pexels-photo-4959374.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'fi',
    name: 'Finnish',
    countries: [
      Country(
          code: 'FI',
          name: 'Finland',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651884/pexels-photo-15651884/free-photo-of-the-national-flag-of-norway.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/4959374/pexels-photo-4959374.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'tr',
    name: '',
    countries: [
      Country(
          code: 'TR',
          name: 'Turkey',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651884/pexels-photo-15651884/free-photo-of-the-national-flag-of-norway.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CY',
          name: 'Cyprus',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651884/pexels-photo-15651884/free-photo-of-the-national-flag-of-norway.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'he',
    name: 'Hebrew',
    countries: [
      Country(
          code: 'IL',
          name: 'Israel',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/17594309/pexels-photo-17594309/free-photo-of-close-up-of-the-flag-of-israel-against-blue-sky.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'pl',
    name: 'Polish',
    countries: [
      Country(
          code: 'PL',
          name: 'Poland',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651836/pexels-photo-15651836/free-photo-of-the-national-flag-of-ethiopia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'uk',
    name: 'Ukrainian',
    countries: [
      Country(
          code: 'UA',
          name: 'Ukraine',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651836/pexels-photo-15651836/free-photo-of-the-national-flag-of-ethiopia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'vi',
    name: 'Vietnamese',
    countries: [
      Country(
          code: 'VN',
          name: 'Vietnam',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651836/pexels-photo-15651836/free-photo-of-the-national-flag-of-ethiopia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'th',
    name: 'Thai',
    countries: [
      Country(
          code: 'TH',
          name: 'Thailand',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651836/pexels-photo-15651836/free-photo-of-the-national-flag-of-ethiopia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'el',
    name: 'Greek',
    countries: [
      Country(
          code: 'GR',
          name: 'Greece',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651836/pexels-photo-15651836/free-photo-of-the-national-flag-of-ethiopia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'CY',
          name: 'Cyprus',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651836/pexels-photo-15651836/free-photo-of-the-national-flag-of-ethiopia.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/8937612/pexels-photo-8937612.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'cs',
    name: 'Czech',
    countries: [
      Country(
          code: 'CZ',
          name: 'Czech Republic',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'hu',
    name: 'Hungarian',
    countries: [
      Country(
          code: 'HU',
          name: 'Hungary',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'ro',
    name: 'Romanian',
    countries: [
      Country(
          code: 'RO',
          name: 'Romania',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'MD',
          name: 'Moldova',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'bg',
    name: 'Bulgarian',
    countries: [
      Country(
          code: 'BG',
          name: 'Bulgaria',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'hr',
    name: 'Croatian',
    countries: [
      Country(
          code: 'HR',
          name: 'Croatia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'sk',
    name: 'Slovak',
    countries: [
      Country(
          code: 'SK',
          name: 'Slovakia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'sr',
    name: 'Serbian',
    countries: [
      Country(
          code: 'RS',
          name: 'Serbia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'ME',
          name: 'Montenegro',
          voiceName: "Ines",
          countryPic: "",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'BA',
          name: 'Bosnia and Herzegovina',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'ms',
    name: 'Malay',
    countries: [
      Country(
          code: 'MY',
          name: 'Malaysia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'BN',
          name: 'Brunei',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15651883/pexels-photo-15651883/free-photo-of-the-national-flag-of-netherlands.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/16046639/pexels-photo-16046639/free-photo-of-blonde-woman-with-eyeglasses-in-leather-jacket-looking-through-window.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'id',
    name: 'Indonesian',
    countries: [
      Country(
          code: 'ID',
          name: 'Indonesia',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/15483698/pexels-photo-15483698/free-photo-of-flag-of-poland.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/3877622/pexels-photo-3877622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
  Language(
    code: 'fa',
    name: 'Persian',
    countries: [
      Country(
          code: 'IR',
          name: 'Iran',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/14037378/pexels-photo-14037378.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/3877622/pexels-photo-3877622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'AF',
          name: 'Afghanistan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/14037378/pexels-photo-14037378.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/3877622/pexels-photo-3877622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      Country(
          code: 'TJ',
          name: 'Tajikistan',
          voiceName: "Ines",
          countryPic:
              "https://images.pexels.com/photos/14037378/pexels-photo-14037378.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          profilePic:
              "https://images.pexels.com/photos/3877622/pexels-photo-3877622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    ],
  ),
];
