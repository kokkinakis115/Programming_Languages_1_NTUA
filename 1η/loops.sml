fun loop_rooms file =
    let
        fun isEmpty (l:'a list): bool =
          (case l of
             [] => true
           | _ => false)

        fun push (x:'a, l:'a list):'a list = x::l
        fun top (l:'a list):'a = hd (l)
        fun pop (l:'a list):'a list = tl (l)

        fun parse file =
            let

                fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

                val inStream = TextIO.openIn file
                val (n, m) = (readInt inStream, readInt inStream)
                val _ = TextIO.inputLine inStream

                fun readLines acc =
                    case TextIO.inputLine inStream of
                        NONE => rev acc
                     |  SOME line => readLines (explode (String.substring (line, 0, m)) :: acc)

                val inputList = readLines []:char list list
                val _ = TextIO.closeIn inStream
            in
                (n, m, inputList)
            end

        val doomed = ref 0
        val (N, M , a) = parse file
        val a = Array2.fromList a
        datatype state = current | unvisited | loop | win
        val status  = Array2.array (N, M, unvisited)
        val stoiva = ref ([] :(int * int) list)

        fun up_date (stat, i, j) = Array2.update (status, i, j, stat)

        fun check_char (x, i, j) =
            case x of
                #"U" => (i-1, j)
            |   #"D" => (i+1, j)
            |   #"R" => (i, j+1)
            |   #"L" => (i, j-1)

        fun stack_update stat =
            if (not (isEmpty (!stoiva)))
                then
                    (if (stat = loop) then ((doomed := (!doomed) + 1)) else ();
                    up_date(stat, #1 (top (!stoiva)), #2 (top (!stoiva))); stoiva := pop (!stoiva); stack_update stat)
            else ()

        fun traverse (i,j) =
            let
                val (tr1, tr2) = (i,j)
                val (ep1, ep2) = check_char (Array2.sub (a, i, j), i, j)
            in
                stoiva := push ((i,j), !stoiva);
                up_date (current, i, j);
                if (ep1 < 0 orelse ep1=N orelse ep2 < 0 orelse ep2 = M)
                    then stack_update (win)
                else if (Array2.sub (status, ep1, ep2) = win)
                    then stack_update (win)
                else if (Array2.sub (status, ep1, ep2) = loop orelse Array2.sub (status, ep1, ep2) = current)
                    then stack_update (loop)
                else if (Array2.sub (status, ep1, ep2) = unvisited)
                    then traverse (ep1, ep2)
                else ()
            end

        fun pp k = (print(Int.toString k ^ "\n"))

        fun loop _ =
            let
              val i = ref 0
            in
              while (!i < N) do
                (let val j = ref 0
                    in while (!j < M) do
                        (if (Array2.sub (status, !i, !j) = unvisited)
                            then (traverse(!i, !j))
                        else ();
                        j := !j + 1)
                    end;
                    i := !i + 1)
            end
    in
        loop 1;
        (pp (!doomed))
    end
