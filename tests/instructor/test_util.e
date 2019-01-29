note
	description: "Summary description for {GRADING_TEST_UTIL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_UTIL
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
		end

feature -- tests
	t1: BOOLEAN
		local
			u: UTIL[INTEGER]
			a: ARRAY[INTEGER]
		do
			comment("t1: test merge sort of empty array")
			create a.make_empty
			Result := u.merge_sort (a).is_empty
			check Result end
		end

	t2: BOOLEAN
		local
			u: UTIL[INTEGER]
			left, right: ARRAY[INTEGER]
			merge, expected: ARRAY[INTEGER]
		do
			comment("t2: merge two empty arrays")
			create left.make_empty
			create right.make_empty
			merge := u.merge(left, right)
			create expected.make_empty
			Result := expected ~ merge
		end

	t3: BOOLEAN
		local
			u: UTIL[INTEGER]
			left, right: ARRAY[INTEGER]
			concat, expected: ARRAY[INTEGER]
		do
			comment("t3: concat two empty arrays")
			create left.make_empty
			create right.make_empty
			concat := u.concatenate(left, right)
			create expected.make_empty
			Result := expected ~ concat
		end
end
