note
	description: "Summary description for {STUDENT_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS
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
			add_boolean_case (agent t4)
		end

feature
	t1: BOOLEAN
		local
			u: UTIL[INTEGER]
			a, b: ARRAY[INTEGER]

		do
			comment("t1: test non-empty array")
			a := <<6,7,5,0,4,3,2,1>>
			b := <<0,1,2,3,4,5,6,7>>

			Result := u.merge_sort(a).is_equal (b)

			check Result end
		end

	t2: BOOLEAN
		local
			u: UTIL[INTEGER]
			a, b: ARRAY[INTEGER]
		do
			comment("t2: test more complex array")
			a := <<1,11,2,10,9,3,8,4,5,7,6>>
			b := <<1,2,3,4,5,6,7,8,9,10,11>>

			Result := u.merge_sort(a).same_items(b)

			check Result end
		end

	t3: BOOLEAN
		do
			comment("t3: describe test t3 here")
			Result := True
		end

	t4: BOOLEAN
		do
			comment("t4: describe test t4 here")
			Result := True
		end
end
