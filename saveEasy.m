function saveEasy(src, event)

key = event.Key
switch key
    
    case  'return'
    curve = src.Children.Children(end);
 
    
    name = src.UserData;
    toSave = [curve.XData', curve.YData'];
    dlmwrite(name, toSave,'Delimiter','\t');
    
    
    case 'rightarrow'
        
        uiresume
    
    
end

end

