pragma solidity >=0.4.2;


contract CarbonFootPrint {

    //Ship Structure
    struct Ship {
        uint32 id; //SNL public id
        string name; //SNL ship name
        uint32 idOrganization; //SNL ID 1
        uint32[] shipFootPrints; //ship co2 emission
    }

    //Ship carbon footprint emission Structure
    struct ShipFootprint {
        uint32 id;
        uint32 co2eq; // emission are saved in grams 1ton = 907185grams
        uint32 idShip; // SNL public id
        uint32 year; //YYYY
        string month; //MM
        uint32 day; //DD
        uint32 idUnit;
    }


    //Organization Structure
    struct Organization {
        uint32 id;
        string name;
        string description;
        uint32[] ships;
    }


    // -- Unit Structure --
    struct Unit {
        uint32 id;
        string measure;
        string initials;
        uint32 base;
        uint32 exp;
        uint32 idUnit;
        bool negative;
    }


    //MAPPINGS REQUIRED TO ACCESS RESPECTIVE STRUCT INFORMATION
    //AND COUNTERS FOR TOTAL NUMBER OF ELEMENTS

    mapping(uint32 => Ship) public ships;
    uint32 public shipsCount;

    mapping(uint32 => Organization) public organizations;
    uint32 public organizationsCount;

    mapping(uint32 => Unit) public units;
    uint32 public unitsCount;

    mapping(uint32 => ShipFootprint) public shipFootPrints;
    uint32 public sfootPrintCount;

    uint32[] public arrayYears;


    //CONSTRUCTOR AND DEFAULT VALUES SETTING

    constructor () public{

        // -- Initalize units
        addUnit("tonne", "t", 10, 0, 1, false);
        addUnit("kilogram", "kg", 10, 3, 1, true);
        addUnit("gram", "g", 10, 6, 1, true);
        addUnit("milligram", "mg", 10, 9, 1, true);
        // -- Current year
        addYear(2022);
    }

    //  ----------------------------- GETTERS -----------------------------

    function getYearsCount() public view returns (uint count){
        return arrayYears.length;
    }

    function getOrgCount() public view returns (uint count){
        return organizationsCount;
    }

    function getShipsCount() public view returns (uint count){
        return shipsCount;
    }



    // -- Get All Footprints For a Specific Ship --
    function getFootPrintsShip(uint32 _ship) public view returns (uint32[] memory footprints){
        return ships[_ship].shipFootPrints;
    }

    //ADDITIONAL FUNCTIONS


    // -- Add New Measure Unit Function --
    function addUnit(string memory _measure, string memory _initials, uint32 _base, uint32 _exp, uint32 _idUnit, bool _negative) public {

        unitsCount++;
        Unit(unitsCount, _measure, _initials, _base, _exp, _idUnit, _negative);
        units[unitsCount] = Unit(unitsCount, _measure, _initials, _base, _exp, _idUnit, _negative);
    }

    // -- Add New Organization Function --
    function addOrganization(string memory _name, string memory _description,
        uint32[] memory _ships) public {
        bool exist = false;

        for (uint32 i = 1; i <= organizationsCount; i++) {
            string memory name = organizations[i].name;
            if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(_name))) {
                exist = true;
            }
        }

        require(!exist, "Organization already registred");


        organizationsCount++;
        organizations[organizationsCount] = Organization(organizationsCount, _name, _description, _ships);

    }

    // -- Add New Product Function --
    function addShip(string memory _name, uint32 _org, uint32[] memory _footPrints) public {

        bool exist = false;
        //require(users[msg.sender].idOrganization == _org, "You need to belong to the organization");
        require(organizations[_org].id != uint32(0), "Organization doesn't exist");

        for (uint32 i = 1; i <= organizationsCount; i++) {
            string memory name = ships[i].name;
            if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(_name))) {
                exist = true;
            }
        }

        require(!exist, "Ship already registred");


        shipsCount++;
        ships[shipsCount] = Ship(shipsCount, _name, _org, _footPrints);
        organizations[_org].ships.push(shipsCount);

    }

    function addYear(uint32 _year) public {
        require(!existsYear(_year), "Year already registred");
        arrayYears.push(_year);
    }

    // -- Year Exists Verification Function --
    function existsYear(uint32 _year) public view returns (bool exists){
        bool exist = false;

        for (uint i = 0; i < arrayYears.length; i++) {
            if (arrayYears[i] == _year) {
                return true;
            }
        }

        return exist;
    }

    // -- Add New Ship Footprint Function --, uint16 _exp
    function addFootPrintShip(uint32 _co2eq, uint32 _idShip, uint32 _year, string memory _month, uint32 day, uint32 idUnit) public {

        //require(users[msg.sender].idOrganization == products[_idProd].idOrganization, "The product doesnt belong to your organization");
        require(ships[_idShip].id != uint32(0), "Ship doesn't exist");

        //if == 1

        sfootPrintCount++;
        shipFootPrints[sfootPrintCount] = ShipFootprint(sfootPrintCount, _co2eq, _idShip, _year, _month, day, idUnit);
        ships[_idShip].shipFootPrints.push(sfootPrintCount);
    }


}
