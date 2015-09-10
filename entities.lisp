#|
 This file is a part of Plump
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.plump.dom)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (case char-code-limit
    (#x10000 (pushnew :plump-utf-16 *features*))
    (#x110000 (pushnew :plump-utf-32 *features*))))

;; According to http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
(defparameter *entity-map*
  (loop with table = (make-hash-table :test 'equal)
        for (key . val) in (append
                            '(("quot" . #\")
                              ("amp" . #\&)
                              ("apos" . #\')
                              ("lt" . #\<)
                              ("gt" . #\>)
                              ("nbsp" . #\ ))
                            #+(or plump-utf-16 plump-utf-32)
                            '(("iexcl" . #\¡)
                              ("cent" . #\¢)
                              ("pound" . #\£)
                              ("curren" . #\¤)
                              ("yen" . #\¥)
                              ("brvbar" . #\¦)
                              ("sect" . #\§)
                              ("uml" . #\¨)
                              ("copy" . #\©)
                              ("ordf" . #\ª)
                              ("laquo" . #\«)
                              ("not" . #\¬)
                              ("shy" . #\ )
                              ("reg" . #\®)
                              ("macr" . #\¯)
                              ("deg" . #\°)
                              ("plusmn" . #\±)
                              ("sup2" . #\²)
                              ("sup3" . #\³)
                              ("acute" . #\´)
                              ("micro" . #\µ)
                              ("para" . #\¶)
                              ("middot" . #\·)
                              ("cedil" . #\¸)
                              ("sup1" . #\¹)
                              ("ordm" . #\º)
                              ("raquo" . #\»)
                              ("frac14" . #\¼)
                              ("frac12" . #\½)
                              ("frac34" . #\¾)
                              ("iquest" . #\¿)
                              ("Agrave" . #\À)
                              ("Aacute" . #\Á)
                              ("Acirc" . #\Â)
                              ("Atilde" . #\Ã)
                              ("Auml" . #\Ä)
                              ("Aring" . #\Å)
                              ("AElig" . #\Æ)
                              ("Ccedil" . #\Ç)
                              ("Egrave" . #\È)
                              ("Eacute" . #\É)
                              ("Ecirc" . #\Ê)
                              ("Euml" . #\Ë)
                              ("Igrave" . #\Ì)
                              ("Iacute" . #\Í)
                              ("Icirc" . #\Î)
                              ("Iuml" . #\Ï)
                              ("ETH" . #\Ð)
                              ("Ntilde" . #\Ñ)
                              ("Ograve" . #\Ò)
                              ("Oacute" . #\Ó)
                              ("Ocirc" . #\Ô)
                              ("Otilde" . #\Õ)
                              ("Ouml" . #\Ö)
                              ("times" . #\×)
                              ("Oslash" . #\Ø)
                              ("Ugrave" . #\Ù)
                              ("Uacute" . #\Ú)
                              ("Ucirc" . #\Û)
                              ("Uuml" . #\Ü)
                              ("Yacute" . #\Ý)
                              ("THORN" . #\Þ)
                              ("szlig" . #\ß)
                              ("agrave" . #\à)
                              ("aacute" . #\á)
                              ("acirc" . #\â)
                              ("atilde" . #\ã)
                              ("auml" . #\ä)
                              ("aring" . #\å)
                              ("aelig" . #\æ)
                              ("ccedil" . #\ç)
                              ("egrave" . #\è)
                              ("eacute" . #\é)
                              ("ecirc" . #\ê)
                              ("euml" . #\ë)
                              ("igrave" . #\ì)
                              ("iacute" . #\í)
                              ("icirc" . #\î)
                              ("iuml" . #\ï)
                              ("eth" . #\ð)
                              ("ntilde" . #\ñ)
                              ("ograve" . #\ò)
                              ("oacute" . #\ó)
                              ("ocirc" . #\ô)
                              ("otilde" . #\õ)
                              ("ouml" . #\ö)
                              ("divide" . #\÷)
                              ("oslash" . #\ø)
                              ("ugrave" . #\ù)
                              ("uacute" . #\ú)
                              ("ucirc" . #\û)
                              ("uuml" . #\ü)
                              ("yacute" . #\ý)
                              ("thorn" . #\þ)
                              ("yuml" . #\ÿ)
                              ("OElig" . #\Œ)
                              ("oelig" . #\œ)
                              ("Scaron" . #\Š)
                              ("scaron" . #\š)
                              ("Yuml" . #\Ÿ)
                              ("fnof" . #\ƒ)
                              ("circ" . #\ˆ)
                              ("tilde" . #\˜)
                              ("Alpha" . #\Α)
                              ("Beta" . #\Β)
                              ("Gamma" . #\Γ)
                              ("Delta" . #\Δ)
                              ("Epsilon" . #\Ε)
                              ("Zeta" . #\Ζ)
                              ("Eta" . #\Η)
                              ("Theta" . #\Θ)
                              ("Iota" . #\Ι)
                              ("Kappa" . #\Κ)
                              ("Lambda" . #\Λ)
                              ("Mu" . #\Μ)
                              ("Nu" . #\Ν)
                              ("Xi" . #\Ξ)
                              ("Omicron" . #\Ο)
                              ("Pi" . #\Π)
                              ("Rho" . #\Ρ)
                              ("Sigma" . #\Σ)
                              ("Tau" . #\Τ)
                              ("Upsilon" . #\Υ)
                              ("Phi" . #\Φ)
                              ("Chi" . #\Χ)
                              ("Psi" . #\Ψ)
                              ("Omega" . #\Ω)
                              ("alpha" . #\α)
                              ("beta" . #\β)
                              ("gamma" . #\γ)
                              ("delta" . #\δ)
                              ("epsilon" . #\ε)
                              ("zeta" . #\ζ)
                              ("eta" . #\η)
                              ("theta" . #\θ)
                              ("iota" . #\ι)
                              ("kappa" . #\κ)
                              ("lambda" . #\λ)
                              ("mu" . #\μ)
                              ("nu" . #\ν)
                              ("xi" . #\ξ)
                              ("omicron" . #\ο)
                              ("pi" . #\π)
                              ("rho" . #\ρ)
                              ("sigmaf" . #\ς)
                              ("sigma" . #\σ)
                              ("tau" . #\τ)
                              ("upsilon" . #\υ)
                              ("phi" . #\φ)
                              ("chi" . #\χ)
                              ("psi" . #\ψ)
                              ("omega" . #\ω)
                              ("thetasym" . #\ϑ)
                              ("upsih" . #\ϒ)
                              ("piv" . #\ϖ)
                              ("ensp" . #\ )
                              ("emsp" . #\ )
                              ("thinsp" . #\ )
                              ("zwnj" . #\ )
                              ("zwj" . #\ )
                              ("lrm" . #\ )
                              ("rlm" . #\ )
                              ("ndash" . #\–)
                              ("mdash" . #\—)
                              ("lsquo" . #\‘)
                              ("rsquo" . #\’)
                              ("sbquo" . #\‚)
                              ("ldquo" . #\“)
                              ("rdquo" . #\”)
                              ("bdquo" . #\„)
                              ("dagger" . #\†)
                              ("Dagger" . #\‡)
                              ("bull" . #\•)
                              ("hellip" . #\…)
                              ("permil" . #\‰)
                              ("prime" . #\′)
                              ("Prime" . #\″)
                              ("lsaquo" . #\‹)
                              ("rsaquo" . #\›)
                              ("oline" . #\‾)
                              ("frasl" . #\⁄)
                              ("euro" . #\€)
                              ("image" . #\ℑ)
                              ("weierp" . #\℘)
                              ("real" . #\ℜ)
                              ("trade" . #\™)
                              ("alefsym" . #\ℵ)
                              ("larr" . #\←)
                              ("uarr" . #\↑)
                              ("rarr" . #\→)
                              ("darr" . #\↓)
                              ("harr" . #\↔)
                              ("crarr" . #\↵)
                              ("lArr" . #\⇐)
                              ("uArr" . #\⇑)
                              ("rArr" . #\⇒)
                              ("dArr" . #\⇓)
                              ("hArr" . #\⇔)
                              ("forall" . #\∀)
                              ("part" . #\∂)
                              ("exist" . #\∃)
                              ("empty" . #\∅)
                              ("nabla" . #\∇)
                              ("isin" . #\∈)
                              ("notin" . #\∉)
                              ("ni" . #\∋)
                              ("prod" . #\∏)
                              ("sum" . #\∑)
                              ("minus" . #\−)
                              ("lowast" . #\∗)
                              ("radic" . #\√)
                              ("prop" . #\∝)
                              ("infin" . #\∞)
                              ("ang" . #\∠)
                              ("and" . #\∧)
                              ("or" . #\∨)
                              ("cap" . #\∩)
                              ("cup" . #\∪)
                              ("int" . #\∫)
                              ("there4" . #\∴)
                              ("sim" . #\∼)
                              ("cong" . #\≅)
                              ("asymp" . #\≈)
                              ("ne" . #\≠)
                              ("equiv" . #\≡)
                              ("le" . #\≤)
                              ("ge" . #\≥)
                              ("sub" . #\⊂)
                              ("sup" . #\⊃)
                              ("nsub" . #\⊄)
                              ("sube" . #\⊆)
                              ("supe" . #\⊇)
                              ("oplus" . #\⊕)
                              ("otimes" . #\⊗)
                              ("perp" . #\⊥)
                              ("sdot" . #\⋅)
                              ("vellip" . #\⋮)
                              ("lceil" . #\⌈)
                              ("rceil" . #\⌉)
                              ("lfloor" . #\⌊)
                              ("rfloor" . #\⌋)
                              ("lang" . #\〈)
                              ("rang" . #\〉)
                              ("loz" . #\◊)
                              ("spades" . #\♠)
                              ("clubs" . #\♣)
                              ("hearts" . #\♥)
                              ("diams" . #\♦)))
        do (setf (gethash key table) val)
        finally (return table))
  "String hash-table containing the entity names and mapping them to their respective characters.")
(declaim (type hash-table *entity-map*))

(defun translate-entity (text &key (start 0) (end (length text)))
  "Translates the given entity identifier (a name, #Dec or #xHex) into their respective strings if possible.
Otherwise returns NIL."
  (declare (optimize (speed 3)))
  (declare (type simple-string text)
           (type fixnum start end))
  (if (char= (elt text start) #\#)
      (when (<= 2 (- end start))
        (code-char
         (if (char= (elt text (+ start 1)) #\x)
             (parse-integer text :start (+ start 2) :end end :radix 16)
             (parse-integer text :start (+ start 1) :end end))))
      (gethash (subseq text start end) *entity-map*)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defparameter *alpha-chars* (coerce "0123456789#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" 'list))
  (declaim (type list *alpha-chars*)))

(defun decode-entities (text &optional remove-invalid)
  "Translates all entities in the text into their character counterparts if possible.
If an entity does not match, it is left in place unless REMOVE-INVALID is non-NIL."
  (declare (optimize (speed 3))
           (type simple-string text)
           (type boolean remove-invalid))
  (with-output-to-string (output)
    (loop with start = 0
          for i from 0 below (length text)
          do (when (char= (aref text i) #\&)
               (write-string text output :start start :end i)
               (setf start i)
               (loop for i from (1+ i) below (length text)
                     do (case (aref text i)
                          (#.*alpha-chars*
                           T)
                          (#\;
                           (let ((entity (translate-entity text :start (+ start 1) :end i)))
                             (cond
                               (entity (write-char entity output))
                               (remove-invalid NIL)
                               (T (write-string text output :start start :end (1+ i)))))
                           (setf start (1+ i) i (1+ i))
                           (return))
                          (T ; Invalid char, not an entity.
                           (return)))))
          finally (write-string text output :start start))))

(defun encode-entities (text &optional stream)
  "Encodes the characters < > & \" with their XML entity equivalents.

If no STREAM is given, it encodes to a new string."
  (declare (optimize (speed 3))
           (type simple-string text))
  (flet ((encode-to (output)
           (loop for c across text
                 do (case c
                      (#\< (write-string "&lt;" output))
                      (#\> (write-string "&gt;" output))
                      (#\" (write-string "&quot;" output))
                      (#\& (write-string "&amp;" output))
                      (t (write-char c output))))))
    (if stream
        (encode-to stream)
        (with-output-to-string (stream)
          (encode-to stream)))))
