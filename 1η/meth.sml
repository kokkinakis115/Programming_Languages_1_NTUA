fun longest (infile : string) =
        let
            fun parse file =
                let

                    fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

                    val inStream = TextIO.openIn file
                    val (M, N) = (readInt inStream, readInt inStream)
                    val _ = TextIO.inputLine inStream

                    fun loop ins =
                        case TextIO.scanStream(Int.scan StringCvt.DEC) ins of
                            SOME int => int :: loop ins
                            | NONE => []


                    val inputList = loop inStream
                    val _ = TextIO.closeIn inStream
                in
                    (M, N, inputList)
                end

            fun pp k = print(Int.toString k ^ "\n")
            fun heada (x::xs) = xs

            val (M,N, array) = parse infile
            val array = map (fn x => ~(x + N)) array
            val n = M+1

            val arr = Array.array (n , 0)
            val LMin = Array.array (n , 0)
            val RMax = Array.array (n , 0)

            val s = ref 0
            val mega = ref (~1)

            fun pSum ([x], i) = ( (s := !s + x); Array.update (arr, i, !s) )
            |   pSum ((x::xs), i) = ((s := !s + x); (Array.update (arr, i, !s)); (pSum (xs, i+1)))

            fun loop1  i =
                    if (i<n)
                        then
                            let
                                val mmin = Int.min (Array.sub (arr, i), Array.sub (LMin, i-1))
                            in
                                Array.update (LMin, i, mmin);
                                loop1 (i+1)
                            end
                    else ()


            fun loop2 i =
                    if (i>=0)
                        then
                            let
                                val mmax = Int.max (Array.sub (arr, i), Array.sub (RMax, i+1))
                            in

                                Array.update (RMax, i, mmax);
                                loop2 (i-1)
                            end
                    else ()



            fun floop (i, j) =
                    if (i<=M andalso j<=M andalso (Array.sub (LMin, i) <= Array.sub (RMax, j)))
                        then (mega := Int.max (!mega, j-i);  floop (i, j+1))

                    else if (i<=M andalso j<=M)
                        then floop (i+1, j)

                    else ()

        in
            pSum (array, 1);
            Array.update (RMax, n-1, Array.sub (arr, n-1));
            loop1 1;
            loop2 (n-2);
            floop (0,0);
            pp (!mega)
        end
