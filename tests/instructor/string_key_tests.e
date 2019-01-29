note
	description: "[
		{STRING_KEY_TESTS} is a deferred implementation of the test cluster.
		It behaves as a parallel class to {SORTED_MAP_ADT} allowing itself
		to act like a factory for its subclasses.
	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STRING_KEY_TESTS

inherit
	ES_TEST

feature  -- types

	map: SORTED_MAP_ADT[STRING, INTEGER]
		deferred
		end

	make_from_sorted_map(a_map: like map): like map
		deferred
		end

	make_from_array(a_arr: like map.as_array): like map
		deferred
		end

feature -- creation

	make
		do
			add_boolean_case (agent t50)
			add_boolean_case (agent t51)
			add_boolean_case (agent t52)
			add_boolean_case (agent t55)
			add_boolean_case (agent t56)
			add_boolean_case (agent t58)
			add_boolean_case (agent t59)
			add_boolean_case (agent t60)
			add_boolean_case (agent t61)
			add_boolean_case (agent t62)
			add_boolean_case (agent t63)
			add_boolean_case (agent t64)
			add_boolean_case (agent t65)
			add_boolean_case (agent t66)
		end
		feature  -- tests

	t50: BOOLEAN
		do
			comment("t50: extend int/person")
			map.extend ("aaa", 4)
			Result := map.out ~ "(aaa,4)"
			check Result end
			map.extend ("a", 1)
			Result := map.out ~ "(a,1)(aaa,4)"
			check Result end
			map.extend ("aa", 2)
			Result := map.out ~ "(a,1)(aa,2)(aaa,4)"
			check Result end
			map.extend ("aaaa", -10)
			Result := map.out ~ "(a,1)(aa,2)(aaa,4)(aaaa,-10)"
			check Result end
		end

	t51: BOOLEAN
		do
			comment("t51: replace_value")
			map.extend ("a", 4)
			Result := map["a"] ~ 4
			check Result end
			map.replace ("a", 5)
			Result := map["a"] ~ 5
			check Result end
		end

	t52: BOOLEAN
		do
			comment("t52: remove key")
			map.extend ("b", 1)
			map.extend ("a", 2)
			map.extend ("c", 3)
			Result := map.out ~ "(a,2)(b,1)(c,3)"
			check Result end
			map.remove("b")
			Result := map.out ~ "(a,2)(c,3)"
			check Result end
			map.remove ("a")
			map.remove ("c")
			Result := map.out ~ ""
			check Result end
		end

	t55: BOOLEAN
		do
			comment("t55: wipe_out")
			map.extend ("a", 2)
			map.extend ("b", 4)
			map.extend ("c", 9)
			map.extend ("d", -4)
			Result := map.out ~ "(a,2)(b,4)(c,9)(d,-4)"
			check Result end
			map.wipe_out
			Result := map.out ~ ""
			check Result end
		end

	t56: BOOLEAN
		do
			comment("t56: replace_key")
			map.extend ("a", 4)
			map.extend ("b", 5)
			Result := map["a"] ~ 4
			check Result end
			map.replace_key ("a", "c")
			Result := map["c"] ~ 4
			check Result end
			Result := map.out ~ "(b,5)(c,4)"
			check Result end
		end

	t58: BOOLEAN
		do
			comment("t58: min/max")
			map.extend ("d", 1)
			map.extend ("c", 5)
			map.extend ("a", 2)
			map.extend ("e", -4)
			map.extend ("b", -1)
			map.extend ("f", 0)
			Result := map.min.key ~ "a"
			check Result end
			Result := map.min.val ~ 2
			check Result end
			Result := map.max.key ~ "f"
			check Result end
			Result := map.max.val ~ 0
			check Result end
		end

	t59: BOOLEAN
		local
			l_list: ARRAY[TUPLE[key: STRING; val: INTEGER]]
		do
			comment("t59: sorted_keys, values and as_array")
			map.extend ("d", 1)
			map.extend ("c", 5)
			map.extend ("a", 2)
			map.extend ("e", -4)
			map.extend ("b", -1)
			map.extend ("f", 0)
			l_list := << ["a", 2], ["b", -1], ["c", 5], ["d", 1], ["e", -4], ["f", 0]>>
			Result :=
				across l_list as list all
					list.item.key ~ map.sorted_keys[list.cursor_index] and
					list.item.key ~ map.as_array[list.cursor_index].key and
					list.item.val ~ map.values[list.cursor_index] and
					list.item.val ~ map.as_array[list.cursor_index].value
				end
			check Result end
		end

	t60: BOOLEAN
		do
			comment("t60: test alias and assign")
			map.extend ("a", 2)
			map["b"] := 7
			Result := map["a"] ~ 2
			check Result end
			map["a"] := 4
			Result := map["a"] ~ 4
			check Result end
			Result := map["b"] ~ 7
			check Result end
			Result := map.out ~ "(a,4)(b,7)"
			check Result end
		end

	t61: BOOLEAN
		local
			l_copy: like map
		do
			comment("t61: test make from map")
			map.extend ("d", 1)
			map.extend ("c", 5)
			map.extend ("a", 2)
			map.extend ("e", -4)
			map.extend ("b", -1)
			map.extend ("f", 0)
			l_copy := make_from_sorted_map(map)
			Result := l_copy ~ map
			check Result end
			Result := l_copy /= map
			check Result end
		end

	t62: BOOLEAN
		local
			l_copy: like map
		do
			comment("t62: test make from array")
			map.extend ("d", 1)
			map.extend ("c", 5)
			map.extend ("a", 2)
			map.extend ("e", -4)
			map.extend ("b", -1)
			map.extend ("f", 0)
			l_copy := make_from_array (map.as_array)
			Result := l_copy ~ map
			check Result end
			Result := l_copy /= map
			check Result end
		end

	t63: BOOLEAN
		do
			comment("t63: losts of insertions/removals(invariant testing)")
			map.extend ("0", 4)
			map.extend ("1", 3)
			map.extend ("2", 7)
			map.extend ("3", 21)
			map.extend ("4", 6)
			map.extend ("5", 3)
			map.extend ("6", 2)
			map.extend ("7", -99)
			map.extend ("8", 7)
			map.extend ("9", 2)
			map.remove ("5")
			map.remove ("1")
			map.remove ("6")
			map.remove ("9")
			map.remove ("8")
			map.remove ("2")
			map.remove ("3")
			map.extend ("3", 476)
			map.extend ("6", 9)
			map.extend ("5", -5)
			map.remove ("5")
			map.remove ("3")
			map.extend ("2", 6)
			map.extend ("10", 1)
			map.remove ("4")
			map.remove ("2")
			map.remove ("6")
			map.remove ("10")
			map.remove ("0")
			map.remove ("7")
			result := map.out ~ ""
			check Result end
		end

	t64: BOOLEAN
		do
			comment("t64: element count")
			Result := map.count = 0
			check Result end
			map.extend ("-5", 2 )
			Result := map.count = 1
			check Result end
			map.extend ("13", -1)
			map.extend ("7", 5)
			map.extend ("0",1)
			Result := map.count = 4
			check Result end
			map.extend ("-10", -4)
			map.extend ("11", 0)
			Result := map.count = 6
			check Result end
			map.remove ("-5")
			map.remove ("7")
			Result := map.count = 4
			check Result end
			map.replace_key ("0", "foo")
			Result := map.count = 4
			check Result end
			map.replace ("11", 3)
			Result := map.count = 4
			check Result end
			map.wipe_out
			Result := map.is_empty
			check Result end
		end

	t65: BOOLEAN
		do
			comment("t65: test has and has_value function")
			map.extend ("7", 2)
			map.extend ("13", 1)
			map.extend ("5", 2)
			map.extend ("0", -10)
			Result := map.has ("7")
			check Result end
			map.replace_key ("7", "3")
			Result := not map.has ("7")
			check Result end
			Result := map.has ("3")
			check Result end
			Result := not map.has ("11")
			check Result end
			Result := map.has_value (2)
			check Result end
			Result := map.has_value (-10)
			check result end
			map.remove ("0")
			Result := not map.has_value (-10)
			check Result end
		end

	t66: BOOLEAN
		do
			comment("t66: test element function")
			map.extend ("7", 2)
			map.extend ("13", 1)
			map.extend ("5", 2)
			map.extend ("0", -10)
			if attached map.element ("7") as el then
				Result := el.key ~ "7" and el.val ~ 2
				check Result end
			end
			if attached map.element ("13") as el then
				Result := el.key ~ "13" and el.val ~ 1
				check Result end
			end
			Result := map.element ("foo") ~ void
			check Result end
		end

end
