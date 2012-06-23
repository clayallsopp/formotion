module Formation
    class RowType
        STRING=0
        EMAIL=1
        PHONE=2
        NUMBER=3
        
        def self.all_types
            [STRING, EMAIL, PHONE, NUMBER]
        end
        
        def self.value(type)
            case type
            when STRING
                "String"
            when EMAIL
                "Email"
            when PHONE
                "Phone"
            when NUMBER
                "Numerical"
            else
                raise "Invalid RowType #{type}"            
            end
        end

        def self.description(type)
            case type
            when STRING
                "example"
            when EMAIL
                "example@mail.com"
            when PHONE
                "(555) 555-5555"
            when NUMBER
                "123456"
            else
                raise "Invalid RowType #{type}"
            end
        end
    end
end