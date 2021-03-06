private ["_roleModelUnits","_unitType","_loadout","_typeLoadout","_unitTypeLoadouts"];
if (!isServer) exitWith {};

_roleModelUnits = synchronizedObjects (_this select 0);
_unitTypeLoadouts = [];
{
	if (_x isKindOf "AllVehicles") then {
		if (_x isKindOf "Man") then {
			_loadout = getUnitLoadout _x;
		} else {
			_loadout = [_x, [missionNamespace, "Var_SavedVehInventory"]] call BIS_fnc_saveInventory;
		};
		if(!isNil "_loadout" && count _loadout > 0) then {
			_unitType = typeOf _x;
			_typeLoadout = [[_unitType, _loadout]];
			_unitTypeLoadouts append _typeLoadout;
		};
		if(isMultiplayer) then {
			deleteVehicle _x;
		};
	};
} forEach _roleModelUnits;

missionNameSpace setVariable ["unitTypeLoadouts", _unitTypeLoadouts, true];
missionNameSpace setVariable ["loadoutInitializationDone", true, true];

{
	_array = [_x];
	[_array, "f_fnc_setGear", _x, true] call BIS_fnc_MP;
	// This should be equivalent: [_x] remoteExec ["f_fnc_setGear", _x];
} forEach allUnits + vehicles;