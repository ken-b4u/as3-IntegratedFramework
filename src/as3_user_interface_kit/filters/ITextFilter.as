package as3_user_interface_kit.filters
{
	import as3_user_interface_kit.views.AbstractTextFieldView;

	public interface ITextFilter
	{
		function filter(source:AbstractTextFieldView):void;
	}
}