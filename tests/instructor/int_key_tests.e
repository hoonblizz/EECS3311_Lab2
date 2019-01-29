note
	description: "[
		{INT_KEY_TESTS} is a deferred implementation of the test cluster. 
		It behaves as a parallel class to {SORTED_MAP_ADT} allowing itself
		to act like a factory for its subclasses.
	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INT_KEY_TESTS

inherit
	ES_TEST

feature  -- types

	map: SORTED_MAP_ADT[INTEGER, STRING]
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
			add_boolean_case (agent t0)
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
			add_boolean_case (agent t15)
			add_boolean_case (agent t16)
		end

feature  -- tests

	t0: BOOLEAN
		do
			comment("t0: extend int/person")
			map.extend (4, "a")
			Result := map.out ~ "(4,a)"
			check Result end
			map.extend (1, "aa")
			Result := map.out ~ "(1,aa)(4,a)"
			check Result end
			map.extend (2, "aaa")
			Result := map.out ~ "(1,aa)(2,aaa)(4,a)"
			check Result end
			map.extend (-10, "aaaa")
			Result := map.out ~ "(-10,aaaa)(1,aa)(2,aaa)(4,a)"
			check Result end
		end

	t1: BOOLEAN
		do
			comment("t1: replace_value")
			map.extend (4, "a")
			Result := map[4] ~ "a"
			check Result end
			map.replace (4, "b")
			Result := map[4] ~ "b"
			check Result end
		end

	t2: BOOLEAN
		do
			comment("t2: remove key")
			map.extend (4, "a")
			map.extend (7, "b")
			map.extend (2, "c")
			Result := map.out ~ "(2,c)(4,a)(7,b)"
			check Result end
			map.remove(4)
			Result := map.out ~ "(2,c)(7,b)"
			check Result end
			map.remove (2)
			map.remove (7)
			Result := map.out ~ ""
			check Result end
		end


	t5: BOOLEAN
		do
			comment("t5: wipe_out")
			map.extend (2, "a")
			map.extend (4, "a")
			map.extend (-2, "a")
			map.extend (7, "b")
			Result := map.out ~ "(-2,a)(2,a)(4,a)(7,b)"
			check Result end
			map.wipe_out
			Result := map.out ~ ""
			check Result end
		end

	t6: BOOLEAN
		do
			comment("t6: replace_key")
			map.extend (4, "a")
			map.extend (5, "b")
			Result := map[4] ~ "a"
			check Result end
			map.replace_key (4, 7)
			Result := map[7] ~ "a"
			check Result end
			Result := map.out ~ "(5,b)(7,a)"
			check Result end
		end


	t8: BOOLEAN
		do
			comment("t8: min/max")
			map.extend (2, "a")
			map.extend (-1, "b")
			map.extend (5, "c")
			map.extend (1, "d")
			map.extend (-4, "e")
			map.extend (0, "f")
			Result := map.min.key ~ -4
			check Result end
			Result := map.min.val ~ "e"
			check Result end
			Result := map.max.key ~ 5
			check Result end
			Result := map.max.val ~ "c"
			check Result end

		end

	t9: BOOLEAN
		local
			l_list: ARRAY[TUPLE[key: INTEGER; val: STRING]]
		do
			comment("t9: sorted_keys, values and as_array")
			map.extend (2, "a")
			map.extend (-1, "b")
			map.extend (5, "c")
			map.extend (1, "d")
			map.extend (-4, "e")
			map.extend (0, "e")
			l_list := << [-4, "e"], [-1, "b"], [0, "e"], [1, "d"], [2, "a"], [5, "c"]>>

			across l_list as list loop
				print("%NMatch 1: " + list.item.key.out + " and " + map.sorted_keys[list.cursor_index].out)
				print("%NMatch 2: " + list.item.key.out + " and " + map.as_array[list.cursor_index].key.out)
				print("%NMatch 3: " + list.item.val.out + " and " + map.values[list.cursor_index].out)
				print("%NMatch 4: " + list.item.val.out + " and " + map.as_array[list.cursor_index].value.out)
			end

			Result :=
				across l_list as list all
					list.item.key ~ map.sorted_keys[list.cursor_index] and
					list.item.key ~ map.as_array[list.cursor_index].key and
					list.item.val ~ map.values[list.cursor_index] and
					list.item.val ~ map.as_array[list.cursor_index].value
				end
			check Result end
		end

	t10: BOOLEAN
		do
			comment("t10: test alias and assign")
			map.extend (2, "4")
			Result := map[2] ~ "4"
			check Result end
			map[2] := "6"
			Result := map[2] ~ "6"
			check Result end
			map[1] := "7"
			Result := map[1] ~ "7"
			check Result end
			Result := map.out ~ "(1,7)(2,6)"
			check Result end
		end

	t11: BOOLEAN
		local
			l_copy: like map
		do
			comment("t11: test make from map")
			map.extend (2, "a")
			map.extend (-1, "b")
			map.extend (5, "c")
			map.extend (1, "d")
			map.extend (-4, "e")
			map.extend (0, "f")
			l_copy := make_from_sorted_map(map)
			Result := l_copy ~ map
			check Result end
			Result := l_copy /= map
			check Result end
		end

	t12: BOOLEAN
		local
			l_copy: like map
		do
			comment("t12: test make from array")
			map.extend (2, "a")
			map.extend (-1, "b")
			map.extend (5, "c")
			map.extend (1, "d")
			map.extend (-4, "e")
			map.extend (0, "f")
			l_copy := make_from_array (map.as_array)
			Result := l_copy ~ map
			check Result end
			Result := l_copy /= map
			check Result end
		end

	t13: BOOLEAN
		do
			comment("t13: losts of insertions/removals(invariant testing)")
			map.extend (0, "-10")
			map.extend (1, "9")
			map.extend (2, "13")
			map.extend (3, "11")
			map.extend (4, "0")
			map.extend (5, "-5")
			map.extend (6, "6")
			map.extend (7, "11")
			map.extend (8, "7")
			map.extend (9, "17")
			map.remove (5)
			map.remove (1)
			map.remove (6)
			map.remove (9)
			map.remove (8)
			map.remove (2)
			map.remove (3)
			map.extend (3, "5")
			map.extend (6, "2")
			map.extend (5, "7")
			map.remove (5)
			map.remove (3)
			map.extend (2, "17")
			map.extend (10, "5")
			map.remove (4)
			map.remove (2)
			map.remove (6)
			map.remove (10)
			map.remove (0)
			map.remove (7)
			result := map.out ~ ""
			check result end
		end

	t14: BOOLEAN
		do
			comment("t14: element count")
			Result := map.count = 0
			check Result end
			map.extend (2, "-5")
			Result := map.count = 1
			check Result end
			map.extend (-1, "13")
			map.extend (5, "7")
			map.extend (1, "0")
			Result := map.count = 4
			check Result end
			map.extend (-4, "-10")
			map.extend (0, "11")
			Result := map.count = 6
			check Result end
			map.remove (2)
			map.remove (5)
			Result := map.count = 4
			check Result end
			map.replace_key (0, 7)
			Result := map.count = 4
			check Result end
			map.replace (7, "9")
			Result := map.count = 4
			check Result end
			map.wipe_out
			Result := map.is_empty
			check Result end
		end

	t15: BOOLEAN
		do
			comment("t15: test has and has_value function")
			map.extend (4, "7")
			map.extend (1, "13")
			map.extend (2, "7")
			map.extend (-10, "0")
			Result := map.has (4)
			check Result end
			map.replace_key (4, 3)
			Result := not map.has (4)
			check Result end
			Result := map.has (2)
			check Result end
			Result := not map.has (9)
			check Result end
			Result := map.has_value ("7")
			check Result end
			Result := map.has_value ("0")
			check result end
			map.remove (-10)
			Result := not map.has_value ("0")
			check Result end
		end

	t16: BOOLEAN
		do
			comment("t16: test element function")
			map.extend (4, "7")
			map.extend (1, "13")
			map.extend (2, "7")
			map.extend (-10, "0")
			if attached map.element (4) as el then
				Result := el.key ~ 4 and el.val ~ "7"
				check Result end
			end
			if attached map.element (1) as el then
				Result := el.key ~ 1 and el.val ~ "13"
				check Result end
			end
			Result := map.element (9) ~ void
			check Result end
		end


end
