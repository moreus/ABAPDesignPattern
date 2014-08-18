*&---------------------------------------------------------------------*
*& Report  ZDP_FACTORYMETHOD3
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_factorymethod3 NO STANDARD PAGE HEADING LINE-SIZE 80.

CLASS cl_abap_typedescr DEFINITION LOAD.

DATA: moff TYPE i
      , slen TYPE i
      , mlen TYPE i.

DEFINE get_clazz_name.
  &2 = cl_abap_classdescr=>get_class_name( &1 ).
  find REGEX 'CLASS=' in &2 MATCH OFFSET moff MATCH LENGTH mlen.
  slen = moff + mlen.
  SHIFT &2 by slen PLACES LEFT.
END-OF-DEFINITION.

CLASS page DEFINITION ABSTRACT.
ENDCLASS.

CLASS skillspage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS educationpage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS experiencepage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS introductionpage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS resultspage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS conclusionpage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS summarypage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS bibliographypage DEFINITION INHERITING FROM page.
ENDCLASS.

CLASS document DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      createpages ABSTRACT
      , pages EXPORTING pages TYPE ANY TABLE.

  PROTECTED SECTION.
    DATA:
      oa_pages_coll TYPE TABLE OF REF TO page.
ENDCLASS.

CLASS document IMPLEMENTATION.
  METHOD pages.
    pages[] = oa_pages_coll[].
  ENDMETHOD.
ENDCLASS.

CLASS resume DEFINITION INHERITING FROM document.
  PUBLIC SECTION.
    METHODS:
      constructor
      , createpages REDEFINITION.
ENDCLASS.

CLASS resume IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    CALL METHOD me->createpages.
  ENDMETHOD.

  METHOD createpages.
    DATA: page TYPE REF TO page.
    CREATE OBJECT page TYPE skillspage.
    APPEND page TO oa_pages_coll.

    CREATE OBJECT page TYPE educationpage.
    APPEND page TO oa_pages_coll.

    CREATE OBJECT page TYPE experiencepage.
    APPEND page TO oa_pages_coll.
  ENDMETHOD.
ENDCLASS.

CLASS report DEFINITION INHERITING FROM document.
  PUBLIC SECTION.
    METHODS:
      constructor
      , createpages REDEFINITION.
ENDCLASS.

CLASS report IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    CALL METHOD me->createpages.
  ENDMETHOD.

  METHOD createpages.
    DATA: page TYPE REF TO page.
    CREATE OBJECT page TYPE introductionpage.
    APPEND page TO oa_pages_coll.

    CREATE OBJECT page TYPE resultspage.
    APPEND page TO oa_pages_coll.

    CREATE OBJECT page TYPE conclusionpage.
    APPEND page TO oa_pages_coll.

    CREATE OBJECT page TYPE summarypage.
    APPEND page TO oa_pages_coll.

    CREATE OBJECT page TYPE bibliographypage.
    APPEND page TO oa_pages_coll.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: oa_document_coll TYPE TABLE OF REF TO document.
    CLASS-METHODS main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: document         TYPE REF TO document
          ,resume           TYPE REF TO resume
          ,report           TYPE REF TO report
          ,page             TYPE REF TO page
          ,class_name       TYPE abap_abstypename
          ,pages_coll       TYPE TABLE OF REF TO page.
    .
    FIELD-SYMBOLS: <fs_document> TYPE REF TO document
                   ,<fs_page>     TYPE REF TO page.

    CREATE OBJECT resume.
    APPEND resume TO oa_document_coll.

    CREATE OBJECT report.
    APPEND report TO oa_document_coll.

*   Loop at all documents
    LOOP AT oa_document_coll ASSIGNING <fs_document>.
*     Call macro to find out which Creator and Product are active
      get_clazz_name <fs_document> class_name.
      CASE class_name.
        WHEN 'RESUME'.
          WRITE: / 'Resume contains following pages:', / sy-uline.
          CALL METHOD <fs_document>->pages( IMPORTING pages = pages_coll ).
*         Loop at all pages in document Resume
          LOOP AT pages_coll ASSIGNING <fs_page>.
            get_clazz_name <fs_page> class_name.
            WRITE: / class_name.
          ENDLOOP.
        WHEN 'REPORT'.
          WRITE: / 'Report contains following pages:', / sy-uline.
          CALL METHOD <fs_document>->pages( IMPORTING pages = pages_coll ).
*         Loop at all pages in document Resume
          LOOP AT pages_coll ASSIGNING <fs_page>.
            get_clazz_name <fs_page> class_name.
            WRITE: / class_name.
          ENDLOOP.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.                    "main
ENDCLASS.                    "mainapp IMPLEMENTATION

START-OF-SELECTION.
  mainapp=>main( ).