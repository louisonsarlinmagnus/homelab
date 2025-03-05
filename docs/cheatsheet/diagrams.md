# Diagrams Mermaid

To create diagrams, mkdocs relies on [Mermaid.js](https://mermaid.js.org/)

## Flowchart

!!! note "Flowchart"

    === "Aspect"
        ``` mermaid
        graph LR
        A[Start] --> B{Error?};
        B -->|Yes| C[Hmm...];
        C --> D[Debug];
        D --> B;
        B ---->|No| E[Yay!];
        ```
    === "Code"
        ````
        ``` mermaid
        graph LR
        A[Start] --> B{Error?};
        B -->|Yes| C[Hmm...];
        C --> D[Debug];
        D --> B;
        B ---->|No| E[Yay!];
        ```
        ````


## Sequence diagram


!!! note "Flowchart"

    === "Aspect"
        ```mermaid
            sequenceDiagram
                participant Alice
                participant Bob
                Alice->>John: Hello John, how are you?
                loop Healthcheck
                    John->>John: Fight against hypochondria
                end
                John-->>Alice: Great!
                John->>Bob: How about you?
                Bob-->>John: Jolly good!
        ```
    === "Code"
        ````
        ```mermaid
        sequenceDiagram
            participant Alice
            participant Bob
            Alice->>John: Hello John, how are you?
            loop Healthcheck
                John->>John: Fight against hypochondria
            end
            John-->>Alice: Great!
            John->>Bob: How about you?
            Bob-->>John: Jolly good!
        ```
        ````

## State diagrams

!!! note "State diagrams"
    === "Aspect"
        ``` mermaid
        stateDiagram-v2
        state fork_state <<fork>>
            [*] --> fork_state
            fork_state --> State2
            fork_state --> State3

            state join_state <<join>>
            State2 --> join_state
            State3 --> join_state
            join_state --> State4
            State4 --> [*]
        ```
    === "Code"
        ````
        ``` mermaid
        stateDiagram-v2
        state fork_state <<fork>>
            [*] --> fork_state
            fork_state --> State2
            fork_state --> State3

            state join_state <<join>>
            State2 --> join_state
            State3 --> join_state
            join_state --> State4
            State4 --> [*]
        ```
        ````

## Class diagram

!!! note "Class diagram"

    === "Aspect"
        ``` mermaid
        classDiagram
        Person <|-- Student
        Person <|-- Professor
        Person : +String name
        Person : +String phoneNumber
        Person : +String emailAddress
        Person: +purchaseParkingPass()
        Address "1" <-- "0..1" Person:lives at
        class Student{
            +int studentNumber
            +int averageMark
            +isEligibleToEnrol()
            +getSeminarsTaken()
        }
        class Professor{
            +int salary
        }
        class Address{
            +String street
            +String city
            +String state
            +int postalCode
            +String country
            -validate()
            +outputAsLabel()  
        }
        ```
    === "Code"
        ````
        ``` mermaid
        classDiagram
        Person <|-- Student
        Person <|-- Professor
        Person : +String name
        Person : +String phoneNumber
        Person : +String emailAddress
        Person: +purchaseParkingPass()
        Address "1" <-- "0..1" Person:lives at
        class Student{
            +int studentNumber
            +int averageMark
            +isEligibleToEnrol()
            +getSeminarsTaken()
        }
        class Professor{
            +int salary
        }
        class Address{
            +String street
            +String city
            +String state
            +int postalCode
            +String country
            -validate()
            +outputAsLabel()  
        }
        ```
        ````

## Entity Relationship Diagram

!!! note "Entity Relationship Diagram"

    === "Aspect"
        ```mermaid
            erDiagram
                CUSTOMER ||--o{ ORDER : places
                ORDER ||--|{ LINE-ITEM : contains
                CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
        ```
    === "Code"
        ````
        ```mermaid
        erDiagram
            CUSTOMER ||--o{ ORDER : places
            ORDER ||--|{ LINE-ITEM : contains
            CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
        ```
        ````
