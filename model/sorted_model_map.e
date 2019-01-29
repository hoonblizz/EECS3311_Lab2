note
	description: "Summary description for {SORTED_MODEL_MAP}."
	author: "Taehoon Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	SORTED_MODEL_MAP [K -> COMPARABLE, V -> ANY]

inherit
	SORTED_MAP_ADT [K,V]

create
	make_empty,
	make_from_array,
	make_from_sorted_map


feature -- model

	model: FUN[K,V]
			-- abstraction function
		do
			Result := implementation
		end

feature{NONE} --attriutes

	implementation: FUN[K,V]
		-- inefficient but abtract implementation
		attribute
			create Result.make_empty
		end


feature{NONE} -- constructors

	make_empty
		-- creates a sorted map without any elements
		do
			implementation.make_empty
		end

	make_from_array (array: ARRAY [TUPLE [key: K; val: V]])
		-- creates a sorted map with the elements of the `array'
		do
			implementation.make_from_array(array)
		end

	make_from_sorted_map (map: SORTED_MAP_ADT [K, V])
		-- creates a sorted map from `other'
		do

			implementation.make_from_array(map.as_array)

		end

feature -- commands

	put (val: V; key: K) --(key: K; val: V)
		-- puts an element of `key' and `value' into map
		-- behaves like `extend' if `key' does not exist
		-- otherwise behaves like `replace'
		-- NOTE: This method follows the convention of `val'/`key'
		do
			print("%NPut starts")
			--implementation.put (val, key)


		end

	extend (key: K; val: V)
		-- inserts an element of `key' and `value' into map
		local
			tempPair: PAIR[K,V]
			tempArray: ARRAY [PAIR[K,V]]
		do
			-- Create empty pair for 'extend' input
			print("%NExtending: " + key.out + " and " + val.out)

			--if implementation.domain.has (key) then
			--	replace(key, val)
			--else
			--	implementation.extend ([key, val])
			--end

			implementation.extend ([key, val])
		end

	remove (key: K)
		-- removes an element whose value is `key' from the map
		do

			implementation.subtract ([key, implementation.item (key)])

		end

	replace (key: K; val: V)
		-- replaces `value' for a given `key'
		do

			implementation.item (key) := val.deep_twin

		end

	replace_key (old_key, new_key: K)
		-- replaces `old_key' with `new_key' for an element
		-- Plan:
		-- create new with new key and old value (deep twin)
		-- Then remove old key
		do

			implementation.extend ([new_key, implementation.item (old_key).deep_twin])
			remove(old_key)

		end

	wipe_out
		--makes an existing map empty
		do
			implementation.make_empty
		end

feature -- queries

	item alias "[]" (key: K): V assign put
		--returns the value associated with `key'
		do
			Result := implementation[key]
		end

	as_array: ARRAY [TUPLE [key: K; value: V]]
		-- returns an array of tuples sorted by key
		local
			u: UTIL[K]
			tempArray: ARRAY[K]
			tempFinalArray: ARRAY [TUPLE [K,V]]
			tempTuple: TUPLE[K,V]
			counter: INTEGER

		do
			--print("%NAs_Array feature: " + implementation.out)


			create tempArray.make_empty
			create tempFinalArray.make_empty

			tempArray := Current.sorted_keys

			counter := 1
			across
				tempArray as i
			loop
				--print("%NCorresponding value: "+ i.item.out + " -> " + implementation.item (i.item).out)
				tempFinalArray.force ([i.item, implementation.item (i.item)], counter)
				counter := counter + 1
			end

			--print("%NImplementation key, val: " + implementation.new_cursor.item.first.out + ", " + implementation.new_cursor.item.second.out)

			Result := tempFinalArray
			--Result := create {ARRAY [TUPLE [K, V]]}.make_empty -- This compiles

		end

	sorted_keys: ARRAY [K]
		-- returns a sorted array of keys
		local
			u: UTIL[K]
			tempArray: ARRAY[K]
			counter: INTEGER
		do
			--print("%NSorted_key feature: " + implementation.out)

			--Result := implementation.domain.as_array
			create tempArray.make_empty
			counter := 1

			across
				implementation.domain as i
			loop
				tempArray.force (i.item, counter)
				counter := counter + 1
			end

			Result := u.merge_sort(tempArray)

			--Result := implementation.domain -- this only compiles

		end

	values: ARRAY [V]
		--returns an array of values sorted by key
		local
			u: UTIL[K]
			tempArray: ARRAY[K]
			tempArray2: ARRAY[V]
			counter: INTEGER
		do
			--print("%NValues feature: " + implementation.out)

			--Result := implementation.range.as_array
			create tempArray2.make_empty
			tempArray := sorted_keys

			counter := 0
			across
				tempArray as i
			loop
				--print("%NGet Value only: " + i.item.out + " and " + implementation.item(i.item).out)

				tempArray2.force (implementation.item (i.item), counter)
				counter := counter + 1
			end

			-- Check as_array
			--print("%NAs array: " + as_array.item (0))

			Result := tempArray2

		end

	has (key: K): BOOLEAN
		-- returns whether `key' exists in the map
		do
			Result := implementation.domain.has(key)
		end

	has_value(val: V): BOOLEAN
			-- returns whether `val' exists in the map
		do
			Result := implementation.range.has (val)
		end

	element (key: K): detachable TUPLE [key: K; val:V]
		-- returns an element of the map (i.e. a tuple [`key', value])
		-- associated with `key'
		local
			tempTuple: TUPLE[K,V]
		do
			--create tempTuple.default_create
			--tempTuple.put (implementation.item (key), key)
			--Result := implementation.
		end

	count: INTEGER
		--returns number of elements in the map
		do
			Result := implementation.count
		end

	is_empty: BOOLEAN
		-- returns whether the map is empty
		do
			Result := implementation.is_empty
		end

	min: TUPLE [key: K; val: V]
		--returns the element with the smallest key in the map
		-- Plan: Result the first one (Assume its sorted)
		do
			--print("%NMin Check: " + Current.out)
			Result := Current.as_array[1]
			--Result := create {TUPLE [K, V]}.default_create -- just compiles
		end

	max: TUPLE [key: K; val: V]
		--returns the element with the largest key in the map
		-- Plan: Result the last one (Assume its sorted)
		do
			--print("%NMax Check: " + Current.out)
			Result := Current.as_array[Current.as_array.count]
			--Result := create {TUPLE [K, V]}.default_create -- just compiles
		end


end
