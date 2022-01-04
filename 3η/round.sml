fun round (infile : string) =
(* fun round (N1, K1, inputList1) = *)
  let
    val sol = ref ((valOf Int.maxInt),0)

    fun parse file =
        let

            fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

            val inStream = TextIO.openIn file
            val (N, K) = (readInt inStream, readInt inStream)
            val _ = TextIO.inputLine inStream

            fun loop ins =
                case TextIO.scanStream(Int.scan StringCvt.DEC) ins of
                    SOME int => int :: loop ins
                    | NONE => []


            val inputList = loop inStream
            val _ = TextIO.closeIn inStream
        in
            (N, K, inputList)
        end

    val (N1,K1, inputList1) = parse infile

    fun solp (N, K, inputList,C) =
        let
          fun create_list 0 _ = []
            | create_list k c = c :: create_list (k-1) c

          fun max (x, y) = if x > y then x else y;

          val curr_state = create_list K C;

          fun compare [] N K [] mmax = (0,max(0,mmax))
            | compare (hdc::tlc) N K (hdl::tll) mmax =
                if hdc <= hdl
                  then
                    let
                      val a = max(hdl - hdc, mmax)
                      val per = compare tlc N K tll a
                      val b = max(hdl - hdc, #2per)
                    in
                      (hdl - hdc + #1per, b)
                    end
                else
                  let
                    val a = max(N - hdc + hdl, mmax)
                    val per = compare tlc N K tll a
                    val b = max(N - hdc + hdl, #2per)
                  in
                    (N  - hdc + hdl + #1per, b)
                  end

          fun viable summ mmax =
            if mmax <= summ - mmax + 1
              then true
            else false

          fun big_one cur_state =
            let
              val (sum,max) = compare inputList N K cur_state 0
              val valid = viable sum max
              val head = C
            in
              if valid then (sum, head, valid)
              else if (max-sum+max-1)<N-2
                then (sum+2*N,head,valid)
              else if (max-sum+max-1)=N-2
                then (sum+N,head,valid)
              else (sum, head, valid)
            end
        in
          big_one curr_state
        end

    fun solp2 (N, K, inputList,C) =
      let
        val i = ref 0
        val (m1,m2,m3) = solp (N, K, inputList,C)
        fun sol_comp (a1,a2,a3) =
          if a1 < #1(!sol)
            then sol := (a1,a2)
          else ()

      in
        sol_comp (m1,m2,m3)
      end

    fun loop (N, K, inputList, C) =
      if N=C then ()
      else
          (solp2 (N, K, inputList, C);
          loop (N, K, inputList, C+1))

    fun pp _ = print(Int.toString (#1(!sol)) ^ " " ^ Int.toString (#2(!sol)) ^ "\n")
  in
    loop (N1, K1, inputList1, 0);
    pp 69420
  end
