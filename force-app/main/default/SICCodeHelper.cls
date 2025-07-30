/**
 * @description Helper class for SIC codes and company filtering
 * @author System
 * @date 2025-01-25
 */
public with sharing class SICCodeHelper {
    
    // SIC Code to Description mapping
    public static Map<String, String> sicCodeToDescription = new Map<String, String>{
        // Section A - Agriculture, Forestry and Fishing
        '01110' => 'Growing of cereals (except rice), leguminous crops and oil seeds',
        '01120' => 'Growing of rice',
        '01130' => 'Growing of vegetables and melons, roots and tubers',
        '01140' => 'Growing of sugar cane',
        '01150' => 'Growing of tobacco',
        '01160' => 'Growing of fibre crops',
        '01190' => 'Growing of other non-perennial crops',
        '01210' => 'Growing of grapes',
        '01220' => 'Growing of tropical and subtropical fruits',
        '01230' => 'Growing of citrus fruits',
        '01240' => 'Growing of pome fruits and stone fruits',
        '01250' => 'Growing of other tree and bush fruits and nuts',
        '01260' => 'Growing of oleaginous fruits',
        '01270' => 'Growing of beverage crops',
        '01280' => 'Growing of spices, aromatic, drug and pharmaceutical crops',
        '01290' => 'Growing of other perennial crops',
        '01300' => 'Plant propagation',
        '01410' => 'Raising of dairy cattle',
        '01420' => 'Raising of other cattle and buffaloes',
        '01430' => 'Raising of horses and other equines',
        '01440' => 'Raising of camels and camelids',
        '01450' => 'Raising of sheep and goats',
        '01460' => 'Raising of swine/pigs',
        '01470' => 'Raising of poultry',
        '01490' => 'Raising of other animals',
        '01500' => 'Mixed farming',
        '01610' => 'Support activities for crop production',
        '01621' => 'Farm animal boarding and care',
        '01629' => 'Support activities for animal production (other than farm animal boarding and care) n.e.c.',
        '01630' => 'Post-harvest crop activities',
        '01640' => 'Seed processing for propagation',
        '01700' => 'Hunting, trapping and related service activities',
        '02100' => 'Silviculture and other forestry activities',
        '02200' => 'Logging',
        '02300' => 'Gathering of wild growing non-wood products',
        '02400' => 'Support services to forestry',
        '03110' => 'Marine fishing',
        '03120' => 'Freshwater fishing',
        '03210' => 'Marine aquaculture',
        '03220' => 'Freshwater aquaculture',
        
        // Section B - Mining and Quarrying
        '05101' => 'Deep coal mines',
        '05102' => 'Open cast coal working',
        '05200' => 'Mining of lignite',
        '06100' => 'Extraction of crude petroleum',
        '06200' => 'Extraction of natural gas',
        '07100' => 'Mining of iron ores',
        '07210' => 'Mining of uranium and thorium ores',
        '07290' => 'Mining of other non-ferrous metal ores',
        '08110' => 'Quarrying of ornamental and building stone, limestone, gypsum, chalk and slate',
        '08120' => 'Operation of gravel and sand pits; mining of clays and kaolin',
        '08910' => 'Mining of chemical and fertilizer minerals',
        '08920' => 'Extraction of peat',
        '08930' => 'Extraction of salt',
        '08990' => 'Other mining and quarrying n.e.c.',
        '09100' => 'Support activities for petroleum and natural gas mining',
        '09900' => 'Support activities for other mining and quarrying',
        
        // Section C - Manufacturing
        '10110' => 'Processing and preserving of meat',
        '10120' => 'Processing and preserving of poultry meat',
        '10130' => 'Production of meat and poultry meat products',
        '10200' => 'Processing and preserving of fish, crustaceans and molluscs',
        '10310' => 'Processing and preserving of potatoes',
        '10320' => 'Manufacture of fruit and vegetable juice',
        '10390' => 'Other processing and preserving of fruit and vegetables',
        '10410' => 'Manufacture of oils and fats',
        '10420' => 'Manufacture of margarine and similar edible fats',
        '10511' => 'Liquid milk and cream production',
        '10512' => 'Butter and cheese production',
        '10519' => 'Manufacture of other milk products',
        '10520' => 'Manufacture of ice cream',
        '10611' => 'Grain milling',
        '10612' => 'Manufacture of breakfast cereals and cereals-based food',
        '10620' => 'Manufacture of starches and starch products',
        '10710' => 'Manufacture of bread; manufacture of fresh pastry goods and cakes',
        '10720' => 'Manufacture of rusks and biscuits; manufacture of preserved pastry goods and cakes',
        '10730' => 'Manufacture of macaroni, noodles, couscous and similar farinaceous products',
        '10810' => 'Manufacture of sugar',
        '10821' => 'Manufacture of cocoa and chocolate confectionery',
        '10822' => 'Manufacture of sugar confectionery',
        '10831' => 'Tea processing',
        '10832' => 'Production of coffee and coffee substitutes',
        '10840' => 'Manufacture of condiments and seasonings',
        '10850' => 'Manufacture of prepared meals and dishes',
        '10860' => 'Manufacture of homogenized food preparations and dietetic food',
        '10890' => 'Manufacture of other food products n.e.c.',
        '10910' => 'Manufacture of prepared feeds for farm animals',
        '10920' => 'Manufacture of prepared pet foods',
        '11010' => 'Distilling, rectifying and blending of spirits',
        '11020' => 'Manufacture of wine from grape',
        '11030' => 'Manufacture of cider and other fruit wines',
        '11040' => 'Manufacture of other non-distilled fermented beverages',
        '11050' => 'Manufacture of beer',
        '11060' => 'Manufacture of malt',
        '11070' => 'Manufacture of soft drinks; production of mineral waters and other bottled waters',
        '12000' => 'Manufacture of tobacco products',
        
        // Section D - Electricity, gas, steam and air conditioning supply
        '35110' => 'Production of electricity',
        '35120' => 'Transmission of electricity',
        '35130' => 'Distribution of electricity',
        '35140' => 'Trade of electricity',
        '35210' => 'Manufacture of gas',
        '35220' => 'Distribution of gaseous fuels through mains',
        '35230' => 'Trade of gas through mains',
        '35300' => 'Steam and air conditioning supply',
        
        // Section E - Water supply, sewerage, waste management and remediation activities
        '36000' => 'Water collection, treatment and supply',
        '37000' => 'Sewerage',
        '38110' => 'Collection of non-hazardous waste',
        '38120' => 'Collection of hazardous waste',
        '38210' => 'Treatment and disposal of non-hazardous waste',
        '38220' => 'Treatment and disposal of hazardous waste',
        '38310' => 'Dismantling of wrecks',
        '38320' => 'Recovery of sorted materials',
        '39000' => 'Remediation activities and other waste management services',
        
        // Section F - Construction
        '41100' => 'Development of building projects',
        '41201' => 'Construction of commercial buildings',
        '41202' => 'Construction of domestic buildings',
        '42110' => 'Construction of roads and motorways',
        '42120' => 'Construction of railways and underground railways',
        '42130' => 'Construction of bridges and tunnels',
        '42210' => 'Construction of utility projects for fluids',
        '42220' => 'Construction of utility projects for electricity and telecommunications',
        '42910' => 'Construction of water projects',
        '42990' => 'Construction of other civil engineering projects n.e.c.',
        '43110' => 'Demolition',
        '43120' => 'Site preparation',
        '43130' => 'Test drilling and boring',
        '43210' => 'Electrical installation',
        '43220' => 'Plumbing, heat and air-conditioning installation',
        '43290' => 'Other construction installation',
        '43310' => 'Plastering',
        '43320' => 'Joinery installation',
        '43330' => 'Floor and wall covering',
        '43341' => 'Painting',
        '43342' => 'Glazing',
        '43390' => 'Other building completion and finishing',
        '43910' => 'Roofing activities',
        '43991' => 'Scaffold erection',
        '43999' => 'Other specialised construction activities n.e.c.',
        
        // Section G - Wholesale and retail trade; repair of motor vehicles and motorcycles
        '45111' => 'Sale of new cars and light motor vehicles',
        '45112' => 'Sale of used cars and light motor vehicles',
        '45190' => 'Sale of other motor vehicles',
        '45200' => 'Maintenance and repair of motor vehicles',
        '45310' => 'Wholesale trade of motor vehicle parts and accessories',
        '45320' => 'Retail trade of motor vehicle parts and accessories',
        '45400' => 'Sale, maintenance and repair of motorcycles and related parts and accessories',
        '46110' => 'Agents selling agricultural raw materials, livestock, textile raw materials and semi-finished goods',
        '46120' => 'Agents involved in the sale of fuels, ores, metals and industrial chemicals',
        '46130' => 'Agents involved in the sale of timber and building materials',
        '46140' => 'Agents involved in the sale of machinery, industrial equipment, ships and aircraft',
        '46150' => 'Agents involved in the sale of furniture, household goods, hardware and ironmongery',
        '46160' => 'Agents involved in the sale of textiles, clothing, fur, footwear and leather goods',
        '46170' => 'Agents involved in the sale of food, beverages and tobacco',
        '46180' => 'Agents specialised in the sale of other particular products',
        '46190' => 'Agents involved in the sale of a variety of goods',
        '46210' => 'Wholesale of grain, unmanufactured tobacco, seeds and animal feeds',
        '46220' => 'Wholesale of flowers and plants',
        '46230' => 'Wholesale of live animals',
        '46240' => 'Wholesale of hides, skins and leather',
        '46310' => 'Wholesale of fruit and vegetables',
        '46320' => 'Wholesale of meat and meat products',
        '46330' => 'Wholesale of dairy products, eggs and edible oils and fats',
        '46341' => 'Wholesale of fruit and vegetable juices, mineral water and soft drinks',
        '46342' => 'Wholesale of wine, beer, spirits and other alcoholic beverages',
        '46350' => 'Wholesale of tobacco products',
        '46360' => 'Wholesale of sugar and chocolate and sugar confectionery',
        '46370' => 'Wholesale of coffee, tea, cocoa and spices',
        '46380' => 'Wholesale of other food, including fish, crustaceans and molluscs',
        '46390' => 'Non-specialised wholesale of food, beverages and tobacco',
        '46410' => 'Wholesale of textiles',
        '46420' => 'Wholesale of clothing and footwear',
        '46431' => 'Wholesale of audio tapes, records, CDs and video tapes and the equipment on which these are played',
        '46439' => 'Wholesale of radio, television goods & electrical household appliances (other than records, tapes, CD\'s & video tapes and the equipment used for playing them)',
        '46440' => 'Wholesale of china and glassware and cleaning materials',
        '46450' => 'Wholesale of perfume and cosmetics',
        '46460' => 'Wholesale of pharmaceutical goods',
        '46470' => 'Wholesale of furniture, carpets and lighting equipment',
        '46480' => 'Wholesale of watches and jewellery',
        '46491' => 'Wholesale of musical instruments',
        '46499' => 'Wholesale of household goods (other than musical instruments) n.e.c',
        '46510' => 'Wholesale of computers, computer peripheral equipment and software',
        '46520' => 'Wholesale of electronic and telecommunications equipment and parts',
        '46610' => 'Wholesale of agricultural machinery, equipment and supplies',
        '46620' => 'Wholesale of machine tools',
        '46630' => 'Wholesale of mining, construction and civil engineering machinery',
        '46640' => 'Wholesale of machinery for the textile industry and of sewing and knitting machines',
        '46650' => 'Wholesale of office furniture',
        '46660' => 'Wholesale of other office machinery and equipment',
        '46690' => 'Wholesale of other machinery and equipment',
        '46711' => 'Wholesale of petroleum and petroleum products',
        '46719' => 'Wholesale of other fuels and related products',
        '46720' => 'Wholesale of metals and metal ores',
        '46730' => 'Wholesale of wood, construction materials and sanitary equipment',
        '46740' => 'Wholesale of hardware, plumbing and heating equipment and supplies',
        '46750' => 'Wholesale of chemical products',
        '46760' => 'Wholesale of other intermediate products',
        '46770' => 'Wholesale of waste and scrap',
        '46900' => 'Non-specialised wholesale trade',
        '47110' => 'Retail sale in non-specialised stores with food, beverages or tobacco predominating',
        '47190' => 'Other retail sale in non-specialised stores',
        '47210' => 'Retail sale of fruit and vegetables in specialised stores',
        '47220' => 'Retail sale of meat and meat products in specialised stores',
        '47230' => 'Retail sale of fish, crustaceans and molluscs in specialised stores',
        '47240' => 'Retail sale of bread, cakes, flour confectionery and sugar confectionery in specialised stores',
        '47250' => 'Retail sale of beverages in specialised stores',
        '47260' => 'Retail sale of tobacco products in specialised stores',
        '47290' => 'Other retail sale of food in specialised stores',
        '47300' => 'Retail sale of automotive fuel in specialised stores',
        '47410' => 'Retail sale of computers, peripheral units and software in specialised stores',
        '47421' => 'Retail sale of mobile telephones',
        '47429' => 'Retail sale of telecommunications equipment other than mobile telephones',
        '47430' => 'Retail sale of audio and video equipment in specialised stores',
        '47510' => 'Retail sale of textiles in specialised stores',
        '47520' => 'Retail sale of hardware, paints and glass in specialised stores',
        '47530' => 'Retail sale of carpets, rugs, wall and floor coverings in specialised stores',
        '47540' => 'Retail sale of electrical household appliances in specialised stores',
        '47591' => 'Retail sale of musical instruments and scores',
        '47599' => 'Retail of furniture, lighting, and similar (not musical instruments or scores) in specialised store',
        '47610' => 'Retail sale of books in specialised stores',
        '47620' => 'Retail sale of newspapers and stationery in specialised stores',
        '47630' => 'Retail sale of music and video recordings in specialised stores',
        '47640' => 'Retail sale of sports goods, fishing gear, camping goods, boats and bicycles',
        '47650' => 'Retail sale of games and toys in specialised stores',
        '47710' => 'Retail sale of clothing in specialised stores',
        '47721' => 'Retail sale of footwear in specialised stores',
        '47722' => 'Retail sale of leather goods in specialised stores',
        '47730' => 'Dispensing chemist in specialised stores',
        '47741' => 'Retail sale of hearing aids',
        '47749' => 'Retail sale of medical and orthopaedic goods in specialised stores (not incl. hearing aids) n.e.c.',
        '47750' => 'Retail sale of cosmetic and toilet articles in specialised stores',
        '47760' => 'Retail sale of flowers, plants, seeds, fertilizers, pet animals and pet food in specialised stores',
        '47770' => 'Retail sale of watches and jewellery in specialised stores',
        '47781' => 'Retail sale in commercial art galleries',
        '47782' => 'Retail sale by opticians',
        '47789' => 'Other retail sale of new goods in specialised stores (not commercial art galleries and opticians)',
        '47791' => 'Retail sale of antiques including antique books in stores',
        '47799' => 'Retail sale of other second-hand goods in stores (not incl. antiques)',
        '47810' => 'Retail sale via stalls and markets of food, beverages and tobacco products',
        '47820' => 'Retail sale via stalls and markets of textiles, clothing and footwear',
        '47890' => 'Retail sale via stalls and markets of other goods',
        '47910' => 'Retail sale via mail order houses or via Internet',
        '47990' => 'Other retail sale not in stores, stalls or markets',
        
        // Section H - Transportation and storage
        '49100' => 'Passenger rail transport, interurban',
        '49200' => 'Freight rail transport',
        '49311' => 'Urban and suburban passenger railway transportation by underground, metro and similar systems',
        '49319' => 'Other urban, suburban or metropolitan passenger land transport (not underground, metro or similar)',
        '49320' => 'Taxi operation',
        '49390' => 'Other passenger land transport',
        '49410' => 'Freight transport by road',
        '49420' => 'Removal services',
        '49500' => 'Transport via pipeline',
        '50100' => 'Sea and coastal passenger water transport',
        '50200' => 'Sea and coastal freight water transport',
        '50300' => 'Inland passenger water transport',
        '50400' => 'Inland freight water transport',
        '51101' => 'Scheduled passenger air transport',
        '51102' => 'Non-scheduled passenger air transport',
        '51210' => 'Freight air transport',
        '51220' => 'Space transport',
        '52101' => 'Operation of warehousing and storage facilities for water transport activities',
        '52102' => 'Operation of warehousing and storage facilities for air transport activities',
        '52103' => 'Operation of warehousing and storage facilities for land transport activities',
        '52211' => 'Operation of rail freight terminals',
        '52212' => 'Operation of rail passenger facilities at railway stations',
        '52213' => 'Operation of bus and coach passenger facilities at bus and coach stations',
        '52219' => 'Other service activities incidental to land transportation, n.e.c.',
        '52220' => 'Service activities incidental to water transportation',
        '52230' => 'Service activities incidental to air transportation',
        '52241' => 'Cargo handling for water transport activities',
        '52242' => 'Cargo handling for air transport activities',
        '52243' => 'Cargo handling for land transport activities',
        '52290' => 'Other transportation support activities',
        '53100' => 'Postal activities under universal service obligation',
        '53201' => 'Licensed carriers',
        '53202' => 'Unlicensed carriers',
        
        // Section I - Accommodation and food service activities
        '55100' => 'Hotels and similar accommodation',
        '55201' => 'Holiday centres and villages',
        '55202' => 'Youth hostels',
        '55209' => 'Other holiday and other collective accommodation',
        '55300' => 'Recreational vehicle parks, trailer parks and camping grounds',
        '55900' => 'Other accommodation',
        '56101' => 'Licenced restaurants',
        '56102' => 'Unlicenced restaurants and cafes',
        '56103' => 'Take-away food shops and mobile food stands',
        '56210' => 'Event catering activities',
        '56290' => 'Other food services',
        '56301' => 'Licenced clubs',
        '56302' => 'Public houses and bars',
        
        // Section J - Information and communication
        '58110' => 'Book publishing',
        '58120' => 'Publishing of directories and mailing lists',
        '58130' => 'Publishing of newspapers',
        '58141' => 'Publishing of learned journals',
        '58142' => 'Publishing of consumer and business journals and periodicals',
        '58190' => 'Other publishing activities',
        '58210' => 'Publishing of computer games',
        '58290' => 'Other software publishing',
        '59111' => 'Motion picture production activities',
        '59112' => 'Video production activities',
        '59113' => 'Television programme production activities',
        '59120' => 'Motion picture, video and television programme post-production activities',
        '59131' => 'Motion picture distribution activities',
        '59132' => 'Video distribution activities',
        '59133' => 'Television programme distribution activities',
        '59140' => 'Motion picture projection activities',
        '59200' => 'Sound recording and music publishing activities',
        '60100' => 'Radio broadcasting',
        '60200' => 'Television programming and broadcasting activities',
        '61100' => 'Wired telecommunications activities',
        '61200' => 'Wireless telecommunications activities',
        '61300' => 'Satellite telecommunications activities',
        '61900' => 'Other telecommunications activities',
        '62011' => 'Ready-made interactive leisure and entertainment software development',
        '62012' => 'Business and domestic software development',
        '62020' => 'Information technology consultancy activities',
        '62030' => 'Computer facilities management activities',
        '62090' => 'Other information technology service activities',
        '63110' => 'Data processing, hosting and related activities',
        '63120' => 'Web portals',
        '63910' => 'News agency activities',
        '63990' => 'Other information service activities n.e.c.',
        
        // Section K - Financial and insurance activities
        '64110' => 'Central banking',
        '64191' => 'Banks',
        '64192' => 'Building societies',
        '64201' => 'Activities of agricultural holding companies',
        '64202' => 'Activities of production holding companies',
        '64203' => 'Activities of construction holding companies',
        '64204' => 'Activities of distribution holding companies',
        '64205' => 'Activities of financial services holding companies',
        '64209' => 'Activities of other holding companies n.e.c.',
        '64301' => 'Activities of investment trusts',
        '64302' => 'Activities of unit trusts',
        '64303' => 'Activities of venture and development capital companies',
        '64304' => 'Activities of open-ended investment companies',
        '64305' => 'Activities of property unit trusts',
        '64306' => 'Activities of real estate investment trusts',
        '64910' => 'Financial leasing',
        '64921' => 'Credit granting by non-deposit taking finance houses and other specialist consumer credit grantors',
        '64922' => 'Activities of mortgage finance companies',
        '64929' => 'Other credit granting n.e.c.',
        '64991' => 'Security dealing on own account',
        '64992' => 'Factoring',
        '64999' => 'Financial intermediation not elsewhere classified',
        '65110' => 'Life insurance',
        '65120' => 'Non-life insurance',
        '65201' => 'Life reinsurance',
        '65202' => 'Non-life reinsurance',
        '65300' => 'Pension funding',
        '66110' => 'Administration of financial markets',
        '66120' => 'Security and commodity contracts dealing activities',
        '66190' => 'Activities auxiliary to financial intermediation n.e.c.',
        '66210' => 'Risk and damage evaluation',
        '66220' => 'Activities of insurance agents and brokers',
        '66290' => 'Other activities auxiliary to insurance and pension funding',
        '66300' => 'Fund management activities',
        
        // Section L - Real estate activities
        '68100' => 'Buying and selling of own real estate',
        '68201' => 'Renting and operating of Housing Association real estate',
        '68202' => 'Letting and operating of conference and exhibition centres',
        '68209' => 'Other letting and operating of own or leased real estate',
        '68310' => 'Real estate agencies',
        '68320' => 'Management of real estate on a fee or contract basis',
        
        // Section M - Professional, scientific and technical activities
        '69101' => 'Barristers at law',
        '69102' => 'Solicitors',
        '69109' => 'Activities of patent and copyright agents; other legal activities n.e.c.',
        '69201' => 'Accounting and auditing activities',
        '69202' => 'Bookkeeping activities',
        '69203' => 'Tax consultancy',
        '70100' => 'Activities of head offices',
        '70210' => 'Public relations and communications activities',
        '70221' => 'Financial management',
        '70229' => 'Management consultancy activities other than financial management',
        '71111' => 'Architectural activities',
        '71112' => 'Urban planning and landscape architectural activities',
        '71121' => 'Engineering design activities for industrial process and production',
        '71122' => 'Engineering related scientific and technical consulting activities',
        '71129' => 'Other engineering activities',
        '71200' => 'Technical testing and analysis',
        '72110' => 'Research and experimental development on biotechnology',
        '72190' => 'Other research and experimental development on natural sciences and engineering',
        '72200' => 'Research and experimental development on social sciences and humanities',
        '73110' => 'Advertising agencies',
        '73120' => 'Media representation services',
        '73200' => 'Market research and public opinion polling',
        '74100' => 'specialised design activities',
        '74201' => 'Portrait photographic activities',
        '74202' => 'Other specialist photography',
        '74203' => 'Film processing',
        '74209' => 'Photographic activities not elsewhere classified',
        '74300' => 'Translation and interpretation activities',
        '74901' => 'Environmental consulting activities',
        '74902' => 'Quantity surveying activities',
        '74909' => 'Other professional, scientific and technical activities n.e.c.',
        '74990' => 'Non-trading company',
        '75000' => 'Veterinary activities',
        
        // Section N - Administrative and support service activities
        '77110' => 'Renting and leasing of cars and light motor vehicles',
        '77120' => 'Renting and leasing of trucks and other heavy vehicles',
        '77210' => 'Renting and leasing of recreational and sports goods',
        '77220' => 'Renting of video tapes and disks',
        '77291' => 'Renting and leasing of media entertainment equipment',
        '77299' => 'Renting and leasing of other personal and household goods',
        '77310' => 'Renting and leasing of agricultural machinery and equipment',
        '77320' => 'Renting and leasing of construction and civil engineering machinery and equipment',
        '77330' => 'Renting and leasing of office machinery and equipment (including computers)',
        '77341' => 'Renting and leasing of passenger water transport equipment',
        '77342' => 'Renting and leasing of freight water transport equipment',
        '77351' => 'Renting and leasing of air passenger transport equipment',
        '77352' => 'Renting and leasing of freight air transport equipment',
        '77390' => 'Renting and leasing of other machinery, equipment and tangible goods n.e.c.',
        '77400' => 'Leasing of intellectual property and similar products, except copyright works',
        '78101' => 'Motion picture, television and other theatrical casting activities',
        '78109' => 'Other activities of employment placement agencies',
        '78200' => 'Temporary employment agency activities',
        '78300' => 'Human resources provision and management of human resources functions',
        '79110' => 'Travel agency activities',
        '79120' => 'Tour operator activities',
        '79901' => 'Activities of tourist guides',
        '79909' => 'Other reservation service activities n.e.c.',
        '80100' => 'Private security activities',
        '80200' => 'Security systems service activities',
        '80300' => 'Investigation activities',
        '81100' => 'Combined facilities support activities',
        '81210' => 'General cleaning of buildings',
        '81221' => 'Window cleaning services',
        '81222' => 'Specialised cleaning services',
        '81223' => 'Furnace and chimney cleaning services',
        '81229' => 'Other building and industrial cleaning activities',
        '81291' => 'Disinfecting and exterminating services',
        '81299' => 'Other cleaning services',
        '81300' => 'Landscape service activities',
        '82110' => 'Combined office administrative service activities',
        '82190' => 'Photocopying, document preparation and other specialised office support activities',
        '82200' => 'Activities of call centres',
        '82301' => 'Activities of exhibition and fair organisers',
        '82302' => 'Activities of conference organisers',
        '82911' => 'Activities of collection agencies',
        '82912' => 'Activities of credit bureaus',
        '82920' => 'Packaging activities',
        '82990' => 'Other business support service activities n.e.c.',
        
        // Section O - Public administration and defence; compulsory social security
        '84110' => 'General public administration activities',
        '84120' => 'Regulation of health care, education, cultural and other social services, not incl. social security',
        '84130' => 'Regulation of and contribution to more efficient operation of businesses',
        '84210' => 'Foreign affairs',
        '84220' => 'Defence activities',
        '84230' => 'Justice and judicial activities',
        '84240' => 'Public order and safety activities',
        '84250' => 'Fire service activities',
        '84300' => 'Compulsory social security activities',
        
        // Section P - Education
        '85100' => 'Pre-primary education',
        '85200' => 'Primary education',
        '85310' => 'General secondary education',
        '85320' => 'Technical and vocational secondary education',
        '85410' => 'Post-secondary non-tertiary education',
        '85421' => 'First-degree level higher education',
        '85422' => 'Post-graduate level higher education',
        '85510' => 'Sports and recreation education',
        '85520' => 'Cultural education',
        '85530' => 'Driving school activities',
        '85590' => 'Other education n.e.c.',
        '85600' => 'Educational support services',
        
        // Section Q - Human health and social work activities
        '86101' => 'Hospital activities',
        '86102' => 'Medical nursing home activities',
        '86210' => 'General medical practice activities',
        '86220' => 'Specialists medical practice activities',
        '86230' => 'Dental practice activities',
        '86900' => 'Other human health activities',
        '87100' => 'Residential nursing care facilities',
        '87200' => 'Residential care activities for learning difficulties, mental health and substance abuse',
        '87300' => 'Residential care activities for the elderly and disabled',
        '87900' => 'Other residential care activities n.e.c.',
        '88100' => 'Social work activities without accommodation for the elderly and disabled',
        '88910' => 'Child day-care activities',
        '88990' => 'Other social work activities without accommodation n.e.c.',
        
        // Section R - Arts, entertainment and recreation
        '90010' => 'Performing arts',
        '90020' => 'Support activities to performing arts',
        '90030' => 'Artistic creation',
        '90040' => 'Operation of arts facilities',
        '91011' => 'Library activities',
        '91012' => 'Archives activities',
        '91020' => 'Museums activities',
        '91030' => 'Operation of historical sites and buildings and similar visitor attractions',
        '91040' => 'Botanical and zoological gardens and nature reserves activities',
        '92000' => 'Gambling and betting activities',
        '93110' => 'Operation of sports facilities',
        '93120' => 'Activities of sport clubs',
        '93130' => 'Fitness facilities',
        '93191' => 'Activities of racehorse owners',
        '93199' => 'Other sports activities',
        '93210' => 'Activities of amusement parks and theme parks',
        '93290' => 'Other amusement and recreation activities n.e.c.',
        
        // Section S - Other service activities
        '94110' => 'Activities of business and employers membership organisations',
        '94120' => 'Activities of professional membership organisations',
        '94200' => 'Activities of trade unions',
        '94910' => 'Activities of religious organisations',
        '94920' => 'Activities of political organisations',
        '94990' => 'Activities of other membership organisations n.e.c.',
        '95110' => 'Repair of computers and peripheral equipment',
        '95120' => 'Repair of communication equipment',
        '95210' => 'Repair of consumer electronics',
        '95220' => 'Repair of household appliances and home and garden equipment',
        '95230' => 'Repair of footwear and leather goods',
        '95240' => 'Repair of furniture and home furnishings',
        '95250' => 'Repair of watches, clocks and jewellery',
        '95290' => 'Repair of personal and household goods n.e.c.',
        '96010' => 'Washing and (dry-)cleaning of textile and fur products',
        '96020' => 'Hairdressing and other beauty treatment',
        '96030' => 'Funeral and related activities',
        '96040' => 'Physical well-being activities',
        '96090' => 'Other service activities n.e.c.',
        
        // Section T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use
        '97000' => 'Activities of households as employers of domestic personnel',
        '98000' => 'Residents property management',
        '98100' => 'Undifferentiated goods-producing activities of private households for own use',
        '98200' => 'Undifferentiated service-producing activities of private households for own use',
        
        // Section U - Activities of extraterritorial organisations and bodies
        '99000' => 'Activities of extraterritorial organisations and bodies',
        '99999' => 'Dormant Company'
    };
    
    /**
     * @description Gets all SIC codes with descriptions for dropdown
     * @return List<SICCodeOption> List of SIC code options
     */
    @AuraEnabled(cacheable=true)
    public static List<SICCodeOption> getSICCodeOptions() {
        List<SICCodeOption> options = new List<SICCodeOption>();
        
        for (String code : sicCodeToDescription.keySet()) {
            options.add(new SICCodeOption(code, sicCodeToDescription.get(code)));
        }
        
        // Sort by description
        options.sort();
        return options;
    }
    
    /**
     * @description Searches SIC codes by code or description
     * @param searchTerm Search term to filter by
     * @return List<SICCodeOption> Filtered list of SIC code options
     */
    @AuraEnabled(cacheable=true)
    public static List<SICCodeOption> searchSICCodes(String searchTerm) {
        if (String.isBlank(searchTerm)) {
            return getSICCodeOptions();
        }
        
        List<SICCodeOption> results = new List<SICCodeOption>();
        String lowerSearchTerm = searchTerm.toLowerCase();
        
        for (String code : sicCodeToDescription.keySet()) {
            String description = sicCodeToDescription.get(code);
            if (code.contains(lowerSearchTerm) || description.toLowerCase().contains(lowerSearchTerm)) {
                results.add(new SICCodeOption(code, description));
            }
        }
        
        results.sort();
        return results;
    }
    
    /**
     * @description Gets the description for a specific SIC code
     * @param sicCode The SIC code to get description for
     * @return String Description of the SIC code
     */
    @AuraEnabled(cacheable=true)
    public static String getSICCodeDescription(String sicCode) {
        return sicCodeToDescription.get(sicCode);
    }
    
    /**
     * @description Gets all available company statuses for filtering
     * @return List<CompanyStatusOption> List of company status options
     */
    @AuraEnabled(cacheable=true)
    public static List<CompanyStatusOption> getCompanyStatusOptions() {
        List<CompanyStatusOption> options = new List<CompanyStatusOption>();
        
        // Common UK company statuses from Companies House
        options.add(new CompanyStatusOption('active', 'Active'));
        options.add(new CompanyStatusOption('dissolved', 'Dissolved'));
        options.add(new CompanyStatusOption('liquidation', 'Liquidation'));
        options.add(new CompanyStatusOption('receivership', 'Receivership'));
        options.add(new CompanyStatusOption('administration', 'Administration'));
        options.add(new CompanyStatusOption('voluntary-arrangement', 'Voluntary Arrangement'));
        options.add(new CompanyStatusOption('converted-closed', 'Converted/Closed'));
        options.add(new CompanyStatusOption('insolvency-proceedings', 'Insolvency Proceedings'));
        options.add(new CompanyStatusOption('registered', 'Registered'));
        options.add(new CompanyStatusOption('removed', 'Removed'));
        options.add(new CompanyStatusOption('closed', 'Closed'));
        options.add(new CompanyStatusOption('open', 'Open'));
        options.add(new CompanyStatusOption('pending', 'Pending'));
        options.add(new CompanyStatusOption('suspended', 'Suspended'));
        
        return options;
    }
    
    /**
     * @description Wrapper class for SIC code options
     */
    public class SICCodeOption implements Comparable {
        @AuraEnabled public String code { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String label { get; set; }
        
        public SICCodeOption(String code, String description) {
            this.code = code;
            this.description = description;
            this.label = code + ' - ' + description;
        }
        
        public Integer compareTo(Object other) {
            SICCodeOption otherOption = (SICCodeOption) other;
            return this.description.compareTo(otherOption.description);
        }
    }
    
    /**
     * @description Wrapper class for company status options
     */
    public class CompanyStatusOption {
        @AuraEnabled public String value { get; set; }
        @AuraEnabled public String label { get; set; }
        
        public CompanyStatusOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
} 