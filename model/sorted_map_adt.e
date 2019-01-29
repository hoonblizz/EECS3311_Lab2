note
	description: "[
		{SORTED_MAP_ADT} outlines all the features that need to be
		implemented in {SORTED_MODEL_MAP} as well as provides all of
		its contracts.
	]"
	author: "JP"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SORTED_MAP_ADT [K -> COMPARABLE, V -> ANY]

inherit

	ITERABLE [TUPLE [K, V]]
		redefine
			is_equal,
			out
		end

feature -- model

	model: FUN[K,V]
			-- abstraction function
		deferred
		end


feature{NONE} -- constructors

	make_empty
			-- creates a sorted map without any elements
		deferred
		end

	make_from_array (array: ARRAY [TUPLE [key: K; val: V]])
			-- creates a sorted map with the elements of the `array'
		require
			all_keys_unique:
				(create {FUN[K,V]}.make_from_array (array)).is_function
		deferred
		end

	make_from_sorted_map (map: SORTED_MAP_ADT [K, V])
			-- creates a sorted map from `other'
		deferred
		end

feature -- commands

	put (val: V; key: K) --(key: K; val: V)
			-- puts an element of `key' and `value' into map
			-- behaves like `extend' if `key' does not exist
			-- otherwise behaves like `replace'
			-- NOTE: This method follows the convention of `val'/`key'
		deferred
		ensure
			inserted: model ~ ((old model.deep_twin) @<+ [key, val])
		end

	extend (key: K; val: V)
			-- inserts an element of `key' and `value' into map
		require
			key_unique: not has (key)
		deferred
		ensure
			extended: model ~ ((old model.deep_twin) + [key, val])
		end

	remove (key: K)
			-- removes an element whose value is `key' from the map
		require
			key_exists: has (key)
		deferred
		ensure
			removed: model ~ ((old model.deep_twin) - [key, old model [key]])
		end

	replace (key: K; val: V)
			-- replaces `value' for a given `key'
		require
			key_exists: has (key)
		deferred
		ensure
			model_updated: model ~ (old model.deep_twin @<+ [key, val])
		end

	replace_key (old_key, new_key: K)
			-- replaces `old_key' with `new_key' for an element
		require
			old_key_exists: has (old_key)
			new_key_unique: not has (new_key)
		deferred
		ensure
			updated: model ~ ((old model.deep_twin) + [new_key, model [new_key]] - [old_key, model [new_key]])
		end

	wipe_out
			--makes an existing map empty
		deferred
		ensure
			empty: model.is_empty
		end

feature -- queries

	item alias "[]" (key: K): V assign put
			--returns the value associated with `key'
		require
			key_exists: has (key)
		deferred
		ensure
			result_correct: Result ~ model [key]
			model_unchanged: model ~ old model.deep_twin
		end

	as_array: ARRAY [TUPLE [key: K; value: V]]
			-- returns an array of tuples sorted by key
		deferred
		ensure
			array_matches_model: create {FUN [K, V]}.make_from_array (Result) ~ model
			keys_sorted:
				across 1 |..| (model.count - 1) as i all
					Result [i.item].key < Result [i.item + 1].key
				end
			model_unchanged: model ~ old model.deep_twin
		end

	sorted_keys: ARRAY [K]
			-- returns a sorted array of keys
		deferred
		ensure
			same_counts: Result.count = model.count
			array_matches_domain: create {SET [K]}.make_from_array (Result) ~ model.domain
			sorted: across 1 |..| (model.count - 1) as i all Result [i.item] < Result [i.item + 1] end
			model_unchanged: model ~ old model.deep_twin
		end

	values: ARRAY [V]
			--returns an array of values sorted by key
		deferred
		ensure
			values_match:
				across 1 |..| count as i all
					as_array[i.item].value ~ Result[i.item]
				end
			array_matches_range: create {BAG[V]}.make_from_array (Result) ~ model.range_as_bag
			model_unchanged: model ~ old model.deep_twin
		end

	has (key: K): BOOLEAN
			-- returns whether `key' exists in the map
		deferred
		ensure
			correct_result: Result = model.domain.has (key)
			model_unchanged: model ~ old model.deep_twin
		end

	has_value(val: V): BOOLEAN
			-- returns whether `val' exists in the map
		deferred
		ensure
			correct_result: Result = model.range.has (val)
			model_unchanged: model ~ old model.deep_twin
		end

	element (key: K): detachable TUPLE [key: K; val:V]
			-- returns an element of the map (i.e. a tuple [`key', value])
			-- associated with `key'
		deferred
		ensure
			correct_result: attached Result implies Result ~ [key, model[key]]
			model_unchanged: model ~ old model.deep_twin
		end

	count: INTEGER
			--returns number of elements in the map
		deferred
		ensure
			result_correct: Result = model.count
			model_unchanged: model ~ old model.deep_twin
		end

	is_empty: BOOLEAN
			-- returns whether the map is empty
		deferred
		ensure
			empty_matches_model: Result = model.is_empty
			model_unchanged: model ~ old model.deep_twin
		end

	min: TUPLE [key: K; val: V]
			--returns the element with the smallest key in the map
		require
			model_has_elements: not is_empty
		deferred
		ensure
			correct_key: Result.key ~ sorted_keys [1]
			correct_val: Result.val ~ model[Result.key]
			model_unchanged: model ~ old model.deep_twin
		end

	max: TUPLE [key: K; val: V]
			--returns the element with the largest key in the map
		require
			model_has_elements: not is_empty
		deferred
		ensure
			correct_key: Result.key ~ sorted_keys [model.count]
			correct_val: Result.val ~ model[Result.key]
			model_unchanged: model ~ old model.deep_twin
		end

feature --iteration
	new_cursor: ITERATION_CURSOR [TUPLE[key: K; value: V]]
			-- Fresh cursor associated with current structure
		do
			Result := as_array.new_cursor
		end

feature --output

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make_empty
			across
				Current as cursor
			loop
				Result.append ("(" + cursor.item.key.out + "," + cursor.item.value.out + ")")
			end
		end

feature{SORTED_MAP_ADT} -- is_equal

	is_equal (other: like current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := model ~ other.model
		end

invariant
	keys_strictly_increasing:
			-- ensures that keys are sorted in order

--		(create {UTIL[K]}).strictly_increasing(sorted_keys)

		across 1 |..| (model.count - 1) as i all sorted_keys [i.item] < sorted_keys [i.item + 1] end

	consistent_count: sorted_keys.count = model.count

		-- ∀k ∈ sorted_keys: k ∈ model.domain
	across sorted_keys as k all model.domain.has (k.item) end


	single_item_min_eq_max: (model.count = 1) implies (min ~ max)

	valid_min_max: (model.count > 1) implies (min.key < max.key)

end
