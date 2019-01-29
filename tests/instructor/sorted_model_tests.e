note
	description: "[
		{SORTED_MODEL_TESTS} inherits from both {INT_KEY_TESTS} and 
		{STRING_KEY_TESTS} and instantiates both of their
		deferred attributes so it can be instantiated. It
		makes use of rename to deal with naming conflicts 
		between the STRING and INT variants.
	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

class
	SORTED_MODEL_TESTS

inherit
	INT_KEY_TESTS
		redefine
			setup, make
		end
	STRING_KEY_TESTS
		rename
			map as s_map,
			make_from_sorted_map as s_make_from_sorted_map,
			make_from_array as s_make_from_array,
			make as s_make
		redefine
			setup
		end

create
	make

feature

	make
		do
			Precursor
			s_make
		end

	setup
		do
			create map.make_empty
			create s_map.make_empty
		end

feature  -- int key tests

	map: SORTED_MODEL_MAP[INTEGER, STRING]
		attribute
			create Result.make_empty
		end

	make_from_sorted_map(a_map: like map): like map
		do
			create Result.make_from_sorted_map(a_map)
		end

	make_from_array(a_arr: like map.as_array): like map
		do
			create Result.make_from_array(a_arr)
		end

feature -- string key tests

	s_map: SORTED_MODEL_MAP[STRING, INTEGER]
		attribute
			create Result.make_empty
		end

	s_make_from_sorted_map(a_map: like s_map): like s_map
		do
			create Result.make_from_sorted_map(a_map)
		end

	s_make_from_array(a_arr: like s_map.as_array): like s_map
		do
			create Result.make_from_array(a_arr)
		end

end
